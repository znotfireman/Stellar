--[[
	A selector that returns the value of a specific attribute from an instance.
]]

local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function AttributeNamed(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	attributeName: string
): Types.StateObject<any>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		table.insert(scope, instance:GetAttributeChangedSignal(attributeName):Connect(refresh))
		return instance:GetAttribute(attributeName)
	end)
end

return AttributeNamed
