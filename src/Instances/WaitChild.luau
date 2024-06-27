--[[
   Returns an unresolved child which uses WaitForChild. Intended to be used with
   Stellar's own [Children] key.
]]

local Types = require("@src/Types")

local function WaitChild(childName: string): (properties: Types.PropertyTable) -> Types.UnresolvedChild
	return function(propertyTable: Types.PropertyTable): Types.UnresolvedChild
		return table.freeze {
			type = "UnresolvedChild" :: "UnresolvedChild",
			mode = "WaitForChild" :: "WaitForChild",
			name = childName,
			props = propertyTable,
		}
	end
end

return WaitChild
