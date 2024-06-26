local Types = require("@src/Types")

local function parseError(error: string): Types.Error
   return {
		type = "Error",
		raw = error,
		message = error:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 2)
   }
end

return parseError
