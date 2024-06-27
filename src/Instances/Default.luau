--[[
   Returns a symbol intended to annotate [Apply] property tables with properties
   that can be overridden and have defaults.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

type DefaultKey = {
   type: "DefaultKey",
   prop: string,
}

local keyCache: { [string]: DefaultKey } = {}

local function Default(propertyName: string): DefaultKey
   if keyCache[propertyName] then
      return keyCache[propertyName]
   end
   local defaultKey = table.freeze {
      type = "DefaultKey" :: "DefaultKey",
      prop = propertyName,
   }
   keyCache[propertyName] = defaultKey
   return defaultKey
end

return Default
