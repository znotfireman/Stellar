--[[
	A selector that returns the children of an instance.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function ChildenOf(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>
): Types.StateObject<{ [number]: Instance }>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return {}
		end
		table.insert(scope, instance.ChildAdded:Connect(refresh))
		table.insert(
			scope,
			instance.ChildRemoved:Connect(function()
				Runtime.deferTask(refresh)
			end)
		)
		return instance:GetChildren()
	end)
end

return ChildenOf
