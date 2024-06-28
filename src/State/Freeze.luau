--[[
	Constructs and returns a state object that follows a given state object
	only if it is frozen.

	TODO: Perhaps see if there's a performant way to do this?
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function Freeze<T>(
	scope: Types.Scope<any>,
	target: Types.StateObject<T>,
	isFrozen: Types.UsedAs<boolean>
): Types.StateObject<T>
	if not castToState(target) then
		Runtime.throwError("invalidStateObject", nil, xtypeof(target), "Freeze()")
	end
	local lastValue = Fusion.peek(target)
	local frozen = Fusion.Computed(scope, function(use)
		local isFrozen = use(isFrozen)
		if not use(isFrozen) then
			lastValue = use(target)
		end
		return lastValue
	end)
	return frozen
end

return Freeze
