--[[
	A selector that returns the first ancestor of an instance that matches the
	given name.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function AncestorsOf(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	name: string
): Types.StateObject<Instance?>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance.AncestryChanged:Connect(refresh))
		return instance:FindFirstAncestor(name) :: any
	end)
end

return AncestorsOf
