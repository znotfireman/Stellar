--[[
	Computes a value given an instance. Intended to be used by selectors.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")

local function computeFromInstance<Returns>(
	scope: Types.Scope<any>,
	process: (
		use: Types.Use,
		scope: Types.Scope<any>,
		refresh: () -> ()
	) -> Returns
): Types.StateObject<Returns>
	local updater = Fusion.Value(scope, os.clock())
	local computed = Fusion.Computed(scope, function(use, scope)
		use(updater)
		return process(use, scope, function()
			updater:set(os.clock())
		end)
	end)
	return computed
end

return computeFromInstance
