--[[
	Constructs and returns a new instance derived from a template, with options
	for setting properties, event handlers and other attributes on the clone
	right away.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

local function Derive<T>(scope: Types.Scope<any>, template: T & Instance): (propertyTable: Types.PropertyTable) -> T
	return function(propertyTable: Types.PropertyTable): T
		local clone = template:Clone()
		if not clone then
			Runtime.throwError("cannotDerive")
		end
		Fusion.Hydrate(scope, template)(propertyTable)
		return clone
	end
end

return Derive
