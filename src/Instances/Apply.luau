--[[
   A special key allowing users to bulk-apply property tables. Aforementioned
   property tables can be annotated with the [Default] key, which enables
   overriding.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Logging
local parseError = require("@src/Logging/parseError")
-- State
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

type DefaultKey = {
	type: "DefaultValue",
	prop: string,
}

local Apply = {} :: Types.SpecialKey
Apply.type = "SpecialKey"
Apply.kind = "Stellar.Apply"
Apply.stage = "self"

local function castToDefaultKey(value: any): DefaultKey
	return if typeof(value) == "table"
			and value.type == "DefaultKey"
			and typeof(value.prop) == "string"
		then value
		else nil
end

local function setProperty(instance: Instance, property: string, value: unknown)
	(instance :: any)[property] = value
end

local function testPropertyAssignable(instance: Instance, property: string)
	(instance :: any)[property] = (instance :: any)[property]
end

local function setInstanceProperty(instance: Instance, property: string, value: unknown)
	local success, err = xpcall(setProperty :: any, parseError, instance, property, value)
	if not success then
		if not pcall(testPropertyAssignable, instance, property) then
			Runtime.throwErrorNonFatal("cannotAssignProperty", nil, instance.ClassName, property)
		else
			-- Property is assignable, but this specific assignment failed. this
			-- typically implies the wrong type was received.
			local givenType = typeof(value)
			local expectedType = typeof((instance :: any)[property])
			if givenType == expectedType then
				Runtime.throwErrorNonFatal("propertySetError", err)
			else
				Runtime.throwErrorNonFatal(
					"invalidPropertyType",
					nil,
					instance.ClassName,
					property,
					expectedType,
					givenType
				)
			end
		end
	end
end

local function bindProperty(
	scope: Types.Scope<unknown>,
	instance: Instance,
	property: string,
	value: Types.UsedAs<unknown>
)
	if castToState(value) then
		local value = value :: Types.StateObject<unknown>
		Fusion.Observer(scope, value :: any):onBind(function()
			setInstanceProperty(instance, property, Fusion.peek(value))
		end)
		return
	end
	setInstanceProperty(instance, property, value)
end

function Apply:apply(scope, value, instance)
	if typeof(value) ~= "table" then
		return Runtime.throwError("invalidApplyValue")
	end
	local propertyTables = value :: { Types.PropertyTable }
	local defaultProps: { [string]: true } = {}
	for _, props in ipairs(propertyTables) do
		if typeof(props) ~= "table" then
			return Runtime.throwError("invalidApplyValue")
		end
		for k, v in pairs(props) do
			if typeof(k) == "string" then
				if defaultProps[k] then
					continue
				end
				bindProperty(scope, instance, k, v)
			elseif castToDefaultKey(k) then
				local k: DefaultKey = k :: any
				local propertyName = string.sub(k.prop, 17, k.prop:len() - 1)
				defaultProps[propertyName] = true
				bindProperty(scope, instance, propertyName, v)
			else
				Runtime.throwError("unrecognizedApplyKey", nil, xtypeof(k))
			end
		end
	end
end

return Apply
