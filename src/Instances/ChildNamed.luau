--[[
	A selector that returns the first child of an instance that matches
	the given name.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function ChildNamed(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	name: string
): Types.StateObject<Instance?>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance.ChildAdded:Connect(refresh))
		table.insert(scope, instance.ChildRemoved:Connect(refresh))
		return instance:FindFirstChild(name) :: any
	end)
end

return ChildNamed
