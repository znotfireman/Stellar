--[[
	Binds a property to a instance. Returns a function to unbind the bounded
	property.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Logging
local parseError = require("@src/Logging/parseError")
-- State
local Observe = require("@src/State/Observe")
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function setProperty(instance: Instance, property: string, value: unknown)
	(instance :: any)[property] = value
end

local function testPropertyAssignable(instance: Instance, property: string)
	(instance :: any)[property] = (instance :: any)[property]
end

local function setInstanceProperty(instance: Instance, property: string, value: unknown)
	local ok, err = xpcall(setProperty :: any, parseError, instance, property, value)
	if ok then
		return
	end
	if not pcall(testPropertyAssignable, instance, property) then
		return Runtime.throwErrorNonFatal("cannotAssignProperty", nil, instance.ClassName, property)
	end
	-- Property is assignable, but this specific assignment failed. This
	-- typically implies the wrong type was received.
	local givenType = typeof(value)
	local expectedType = typeof((instance :: any)[property])
	if givenType == expectedType then
		return Runtime.throwErrorNonFatal("propertySetError", err)
	end
	Runtime.throwErrorNonFatal("invalidPropertyType", nil, instance.ClassName, property, expectedType, givenType)
end

local function bindInstanceProperty(
	scope: Types.Scope<any>,
	instance: Instance,
	property: string,
	value: Types.UsedAs<any>
): (() -> ())?
	if castToState(value) then
		local value = value :: Types.StateObject<any>
		return Fusion.Observer(scope, value :: any):onBind(function()
			setInstanceProperty(instance, property, Fusion.peek(value))
		end)
	end
	setInstanceProperty(instance, property, value)
	return nil
end

local function BindProperty(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	propertyName: string,
	value: Types.UsedAs<any>
): () -> ()
	if typeof(propertyName) ~= "string" then
		Runtime.throwError("invalidPropertyName", nil, xtypeof(propertyName), "BindAttribute()")
	end
	if typeof(instance) == "Instance" then
		return Observe(scope, value, function()
			instance:SetAttribute(propertyName, value)
		end)
	end
	local disconnect: Types.Computed<() -> ()?> = Fusion.Computed(scope, function(use, scope)
		local instance = use(instance)
		if not instance then
			return nil
		end
		return bindInstanceProperty(scope, instance, propertyName, value) :: any
	end)
	local connected = true
	return function()
		if not connected then
			return Runtime.throwError("unbindedTwice", nil, "bounded property '" .. propertyName .. "'")
		end
		connected = false
		local disconnect = Fusion.peek(disconnect)
		if disconnect then
			disconnect()
		end
	end
end

return BindProperty
