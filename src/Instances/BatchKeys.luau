--[[
   A special key allowing users to bulk-apply special keys at the designated
   stage regardless of it's predefined stage.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Instances
local castToSpecialKey = require("@src/Instances/castToSpecialKey")

type Stage = "self" | "ancestor" | "descendants" | "observer"

local keyCache: { [Stage]: Types.SpecialKey } = {}

local function castToStage(value: any): Stage?
   return if value == "self" or value == "ancestor" or value == "descendants" or value == "observer" then value else nil
end

local function BatchKeys(stage: Stage): Types.SpecialKey
   if keyCache[stage] then
      return keyCache[stage]
   end
   if not castToStage(stage) then
      return Runtime.throwError("unrecognizedPropertyStage", nil, tostring(stage))
   end

   local specialKey = {} :: Types.SpecialKey
   specialKey.type = "SpecialKey"
   specialKey.kind = "Stellar.BatchKeys<" .. stage .. ">"
   specialKey.stage = stage

   function specialKey:apply(scope, value, instance)
      if typeof(value) ~= "table" then
         return Runtime.throwError("unrecognizedBatchKeys")
      end
      local batch: { [Types.SpecialKey]: any } = value :: any
      for k: Types.SpecialKey, v in pairs(batch) do
         if not castToSpecialKey(k) then
            return Runtime.throwError("invalidSpecialKey", nil, "[BatchKeys]")
         end
         k:apply(scope, value, instance)
      end
   end

   keyCache[stage] = specialKey
   table.freeze(specialKey)
   return specialKey
end

return BatchKeys
