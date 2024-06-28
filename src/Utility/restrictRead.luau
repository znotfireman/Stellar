--[[
	Restricts the reading of missing members for a table.
]]

local Runtime = require("@src/Runtime")

local function restrictRead<T>(name: string?, target: T & {}): T
	local name = tostring(name) or tostring(target)
	if typeof(target) ~= "table" then
		return target
	end
	local target = target :: { [any]: any }
	local proxy = newproxy(true)
	getmetatable(proxy).__index = function(self: any, key: any)
		local value = (target :: any)[key]
		if typeof(value) == "table" then
			return restrictRead(name, key)
		end
		if (target :: any)[key] then
			return (target :: any)[key]
		end
		return Runtime.throwError("strictReadError", nil, "'" .. name .. "'")
	end
	getmetatable(proxy).__newindex = function()
		return Runtime.throwError("strictWriteError", nil, "'" .. name .. "'")
	end
	getmetatable(proxy).__tostring = function()
		return name
	end
	getmetatable(proxy).__metatable = "This metatable is locked."
	for k, v in pairs(target) do
		target[k] = restrictRead(name, v)
	end
	return proxy
end

return restrictRead
