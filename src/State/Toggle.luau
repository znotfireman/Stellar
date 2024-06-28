--[[
	Constructs and returns a state object that toggles betweenvalue and a
	fallback based on a target state's truthiness.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local Switch = require("@src/State/Switch")
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function Toggle<Default, Fallback>(
	scope: Types.Scope<any>,
	target: Types.StateObject<any>,
	options: {
		show: () -> Default,
		fallback: (() -> Fallback)?,
	}
): Types.StateObject<Default | Fallback>
	if not castToState(target) then
		Runtime.throwError("invalidStateObject", nil, xtypeof(target), "Toggle()")
	end
	if typeof(options) ~= "table" then
		Runtime.throwError("invalidSwitchOptions", nil, xtypeof(options), "Switch()")
	end
	if typeof(options.show) ~= "function" then
		Runtime.throwError("invalidSwitchOption", nil, "show", xtypeof(options.show))
	end
	if options.fallback ~= nil and typeof(options.fallback) ~= "function" then
		Runtime.throwError("invalidSwitchOption", nil, "fallback", xtypeof(options.show))
	end
	local truthy = Fusion.Computed(scope, function(use)
		return not not use(target)
	end)
	return (
		Switch(scope, truthy, {
			[true] = options.show,
			[false] = options.fallback :: any,
		}) :: any
	) :: Types.StateObject<Default | Fallback>
end

return Toggle
