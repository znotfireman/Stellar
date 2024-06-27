--[[
	Passes through a table of children. Intended to be used with strict type
	checking environments so Luau doesn't incorrectly types a table of children.
	Modification of Fusion's own `Child()` function that uses Stellar's own
	Child type.
]]

local Types = require("@src/Types")

local function Child(child: { Types.Child }): Types.Child
	return child
end

return Child
