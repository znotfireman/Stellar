--[[
	A selector that returns the first descendant of an instance that inherits
	the given class name.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function DescendantWhichIsA(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	className: string
): Types.StateObject<Instance?>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance.DescendantAdded:Connect(refresh))
		table.insert(
			scope,
			instance.DescendantRemoving:Connect(function()
				Runtime.deferTask(refresh)
			end)
		)
		for _, descendant in ipairs(instance:GetDescendants()) do
			if descendant:IsA(className) then
				return descendant :: any
			end
		end
		return nil
	end)
end

return DescendantWhichIsA
