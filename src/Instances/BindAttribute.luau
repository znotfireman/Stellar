--[[
	Binds an attribute to a instance. Returns a function to unbind the bounded
	attribute.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local Observe = require("@src/State/Observe")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function BindAttribute(
	scope: Types.Scope<any>,
	instance: Types.UsedAs<Instance?>,
	attributeName: string,
	value: Types.StateObject<any>
): () -> ()
	if typeof(attributeName) ~= "string" then
		Runtime.throwError("invalidAttributeName", nil, xtypeof(attributeName), "BindAttribute()")
	end
	if typeof(instance) == "Instance" then
		return Observe(scope, value, function()
			instance:SetAttribute(attributeName, value)
		end)
	end
	local disconnect: Types.Computed<() -> ()?> = Fusion.Computed(scope, function(use, scope)
		local instance = use(instance)
		if not instance then
			return nil
		end
		return Observe(scope, value, function()
			instance:SetAttribute(attributeName, value)
		end) :: any
	end)
	local connected = true
	return function()
		if not connected then
			return Runtime.throwError("unbindedTwice", nil, "bounded attribute")
		end
		connected = false
		local disconnect = Fusion.peek(disconnect)
		if disconnect then
			disconnect()
		end
	end
end

return BindAttribute
