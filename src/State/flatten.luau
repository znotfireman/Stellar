--[[
   Extracts a constant value from a state object of any depth. Pass a `Use`
   callback and it will use that.

   FUTURE: Luau's type system can't provide precise types for this function yet.
]]

local Fusion = require("@src/Fusion")
local Types = require("@src/Types")
-- State
local castToState = require("@src/State/castToState")

local function flatten(target: Types.StateObject<any>, use: Types.Use?): any
	local unwrap: Types.Use = use or Fusion.peek
	while castToState(target) do
		target = unwrap(target)
	end
	return target
end

return flatten
