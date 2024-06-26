local Types = require("@src/Types")

local function getPath(trace: string)
   if trace:sub(#trace - 4, #trace) == ".luau" then
      trace = trace:sub(1, #trace - 5)
   elseif trace:sub(#trace - 3, #trace) == ".lua" then
      trace = trace:sub(1, #trace - 4)
   end
   return trace:split(trace:match("%w+/") and "/" or ".")
end

local path = getPath(debug.info(1, "s"))
local root = path[#path - 1]

local function getTraceDepth(trace: string): number
   local stack = 1
   local path = getPath(trace)
   while path[#path] == root or path[#path - 1] == root do
      stack += 1
      path = getPath(debug.info(stack, "s"))
   end
   return stack
end

local function parseError(error: string): Types.Error
   return {
      type = "Error",
      raw = error,
      message = error:gsub("^.+:%d+:%s*", ""),
      trace = debug.traceback(nil, getTraceDepth(debug.info(1, "s"))),
   }
end

return parseError
