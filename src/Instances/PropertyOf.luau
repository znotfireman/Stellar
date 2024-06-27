--[[
	A selector that returns the property of an instance.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Utility
local computeFromInstance = require("@src/Utility/computeFromInstance")

local function getProperty(instance: Instance, property: string): any
	return (instance :: any)[property]
end

local function PropertyOf(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	propertyName: string
): Types.StateObject<any>
	return computeFromInstance(scope, function(use, scope, refresh)
		local instance: Instance = use(instance)
		if not instance then
			return nil
		end
		local ok = pcall(getProperty, instance, propertyName)
		if not ok then
			Runtime.throwErrorNonFatal("cannotAssignProperty", nil, instance.ClassName, propertyName)
		end
		table.insert(scope, instance:GetPropertyChangedSignal(propertyName):Connect(refresh))
		return getProperty(instance, propertyName)
	end)
end

return PropertyOf
