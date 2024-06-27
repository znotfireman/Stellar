--[[
	A selector that returns the first child of an instance that is exactly
	the given class name.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function ChildOfClass(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	className: string
): Types.StateObject<Instance?>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance.ChildAdded:Connect(refresh))
		table.insert(scope, instance.ChildRemoved:Connect(refresh))
		for _, child in ipairs(instance:GetChildren()) do
			if child.ClassName == className then
				return child :: any
			end
		end
		return nil
	end)
end

return ChildOfClass
