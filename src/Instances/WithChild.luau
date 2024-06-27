--[[
   Returns an unresolved child which uses FindFirstChild. Intended to be used with
   Stellar's own [Children] key.
]]

local Types = require("@src/Types")

local function WithChild(name: string): (properties: Types.PropertyTable) -> Types.UnresolvedChild
	return function(properties: Types.PropertyTable): Types.UnresolvedChild
		return table.freeze {
			type = "UnresolvedChild" :: "UnresolvedChild",
			mode = "FindFirstChild" :: "FindFirstChild",
			name = name,
			props = properties,
		}
	end
end

return WithChild
