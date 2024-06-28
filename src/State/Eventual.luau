--[[
	Constructs and returns a state object derived from an asynchronous
	computation. Behaves like a yieldable Computed.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Logging
local parseError = require("@src/Logging/parseError")
-- State
local Observe = require("@src/State/Observe")
local ReadOnly = require("@src/State/ReadOnly")
local castToState = require("@src/State/castToState")
-- Utility
local extendedCleanup = require("@src/Utility/extendedCleanup")

local function Eventual<T, S>(
	scope: Types.Scope<S>,
	defaultValue: T,
	computation: (become: <T>(value: T) -> T, use: Types.Use, scope: Types.Scope<S>) -> T
): Types.StateObject<T>
	local currentValue = Fusion.Value(scope, defaultValue)
	local dependencies: { [Types.StateObject<any>]: () -> () } = {}
	local innerScope: Types.Scope<any>? = nil

	local function become<T>(value: T): T
		currentValue:set(value)
		return value
	end

	local function resetDependencies()
		if innerScope then
			extendedCleanup(innerScope)
			innerScope = nil
		end
		if next(dependencies) ~= nil then
			for _, unbind in pairs(dependencies) do
				pcall(unbind)
			end
			table.clear(dependencies)
		end
	end

	local function performUpdate()
		resetDependencies()
		local function use<T>(target: Types.UsedAs<T>): T
			if not castToState(target) then
				return target :: any
			end
			local stateObject = target :: Types.StateObject<T>
			dependencies[stateObject] = Observe(scope, stateObject, function()
				Runtime.spawnTask(performUpdate)
			end)
			return Fusion.peek(stateObject)
		end

		innerScope = Fusion.innerScope(scope)
		local ok, result = xpcall(computation, parseError, become, use, innerScope :: any)
		if not ok then
			Runtime.throwErrorNonFatal("callbackError", result :: any)
		else
			currentValue:set(result)
		end
	end

	Runtime.spawnTask(performUpdate)
	return ReadOnly(scope, currentValue)
end

return Eventual
