local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

local function symbol(kind: string): Types.Symbol
	return setmetatable({}, {
		__index = function(_: any, key: any): any
			if key == "string" then
				return "Symbol"
			elseif key == "kind" then
				return kind
			end
			return Runtime.throwError("strictReadError", nil, tostring(key), "a symbol")
		end,
		__metatable = "This metatable is locked.",
		__newindex = function(): never
			return Runtime.throwError("strictWriteError", nil, "a symbol")
		end,
		__tostring = function()
			return "Symbol<" .. kind .. ">"
		end,
	}) :: any
end

local Symbols = {}

-- Used in `Switch()` to indicate a default value.
local switchDefault = symbol("SwitchDefault") :: any
Symbols.SwitchDefault = switchDefault :: { type: "Symbol", kind: "SwitchDefault" }

table.freeze(Symbols)
return Symbols
