--[[
   Returns an unresolved child which uses FindFirstChild. Intended to be used with
   Stellar's own [Children] key.
]]

local Types = require("@src/Types")

local function WithChild(childName: string): (propertyTable: Types.PropertyTable) -> Types.UnresolvedChild
	return function(propertyTable: Types.PropertyTable): Types.UnresolvedChild
		return table.freeze {
			type = "UnresolvedChild" :: "UnresolvedChild",
			mode = "FindFirstChild" :: "FindFirstChild",
			name = childName,
			props = propertyTable,
		}
	end
end

return WithChild
