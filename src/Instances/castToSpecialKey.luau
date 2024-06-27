--[[
   Only returns the value if it is a Fusion special key.
]]

local Types = require("@src/Types")

type Stage = "self" | "ancestor" | "descendants" | "observer"

local function castToStage(value: any): Stage?
   return if value == "self" or value == "ancestor" or value == "descendants" or value == "observer" then value else nil
end

local function castToSpecialKey(value: any): Types.SpecialKey?
   return if typeof(value) == "table"
         and value.type == "SpecialKey"
         and typeof(value.kind) == "string"
         and castToStage(value.stage)
         and typeof(value.apply) == "function"
      then value
      else nil
end

return castToSpecialKey
