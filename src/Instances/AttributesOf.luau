--[[
	A selector that returns the attributes of an instance.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function AttributesOf(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>
): Types.StateObject<{ [string]: any }>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return {}
		end
		table.insert(scope, instance.AttributeChanged:Connect(refresh))
		return instance:GetAttributes()
	end)
end

return AttributesOf
