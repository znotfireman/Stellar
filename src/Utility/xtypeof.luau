--[[
	Extended `typeof()`. If given an object with a type string field, returns
	that. Otherwise, returns the `typeof()` of said object.
]]

local function xtypeof(value: any): string
	if typeof(value) == "table" and typeof(value.type) == "string" then
		return value.type
	end
	return typeof(value)
end

return xtypeof
