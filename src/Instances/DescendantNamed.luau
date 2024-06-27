--[[
	A selector that returns the first descendant of an instance that matches
	the given name.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function DescendantNamed(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	name: string
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
		return instance:FindFirstChild(name, true) :: any
	end)
end

return DescendantNamed
