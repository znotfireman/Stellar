--[[
   Returns an unresolved child which uses WaitForChild. Intended to be used with
   Stellar's own [Children] key.
]]

local Types = require("@src/Types")

local function WaitChild(name: string): (properties: Types.PropertyTable) -> Types.UnresolvedChild
	return function(properties: Types.PropertyTable): Types.UnresolvedChild
		return table.freeze {
			type = "UnresolvedChild" :: "UnresolvedChild",
			mode = "WaitForChild" :: "WaitForChild",
			name = name,
			props = properties,
		}
	end
end

return WaitChild
