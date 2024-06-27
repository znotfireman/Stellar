--[[
	Constructs and returns a state object following a given state object and
	outputs a matching value from pairs of given option.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local ObserveBind = require("@src/State/ObserveBind")
local ReadOnly = require("@src/State/ReadOnly")
local castToState = require("@src/State/castToState")
-- Utility
local Symbols = require("@src/Utility/Symbols")
local xtypeof = require("@src/Utility/xtypeof")

local SWITCH_DEFAULT = Symbols.SwitchDefault

local function Switch<Options, Result>(
	scope: Types.Scope<any>,
	target: Types.StateObject<Options>,
	options: { [Options | typeof(SWITCH_DEFAULT)]: () -> Result }
): Types.StateObject<Result>
	if Runtime.isStrict() then
		if not castToState(target) then
			Runtime.throwError("invalidStateObject", nil, xtypeof(target), "Switch()")
		end
		if typeof(options) ~= "table" then
			Runtime.throwError("invalidSwitchOptions", nil, xtypeof(options), "Switch()")
		end
		for k, v in pairs(options) do
			if typeof(v) ~= "function" then
				Runtime.throwError("invalidSwitchOption", nil, tostring(k), xtypeof(v))
			end
		end
	end
	local currentValue: Types.Value<Result> = Fusion.Value(scope, nil :: any)
	ObserveBind(scope, target, function()
		local target = Fusion.peek(target)
		if options[target] then
			currentValue:set(options[target]())
		end
		if options[SWITCH_DEFAULT] then
			currentValue:set(options[SWITCH_DEFAULT]())
		end
	end)
	return ReadOnly(scope, currentValue)
end

return Switch
