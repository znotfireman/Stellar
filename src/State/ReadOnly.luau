--[[
	Constructs and returns a state object that reflects another state objects
	value. Intended to be used to make objects read only.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function ReadOnly<T>(scope: Types.Scope<any>, target: Types.StateObject<T>): Types.StateObject<T>
	if not castToState(target) then
		Runtime.throwError("invalidStateObject", nil, xtypeof(target), "ReadOnly()")
	end
	return Fusion.Computed(scope, function(use)
		return use(target)
	end)
end

return ReadOnly
