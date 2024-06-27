--[[
	A selector that returns the ancestors of an instance, sorted from closest
	to furthest.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function AncestorsOf(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>
): Types.StateObject<{ [number]: Instance }>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		table.insert(scope, instance.AncestryChanged:Connect(refresh))
		local ancestry, ancestor: Instance? = {}, instance
		while ancestor do
			ancestor = ancestor.Parent
			table.insert(ancestry, ancestor)
		end
		return ancestry
	end)
end

return AncestorsOf
