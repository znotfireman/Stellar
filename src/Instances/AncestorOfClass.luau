--[[
	A selector that returns the first ancestor of an instance that is exactly
	the given class name.
]]

local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function AncestorOfClass(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	className: string
): Types.StateObject<Instance?>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance.AncestryChanged:Connect(refresh))
		local ancestor = instance
		while ancestor do
			if not ancestor.Parent then
				break
			end
			if ancestor.ClassName == className then
				return ancestor :: any
			end
			ancestor = ancestor.Parent
		end
		return nil
	end)
end

return AncestorOfClass
