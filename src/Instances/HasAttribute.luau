--[[
	A selector that returns if an instance has a specific attribute.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function HasAttribute(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	attributeName: string
): Types.StateObject<boolean>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return false
		end
		table.insert(scope, instance:GetAttributeChangedSignal(attributeName):Connect(refresh))
		return instance:GetAttribute(attributeName) ~= nil
	end)
end

return HasAttribute
