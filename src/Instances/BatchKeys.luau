local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

type Stage = "self" | "ancestor" | "descendants" | "observer"

local keyCache: { [Stage]: Types.SpecialKey } = {}

local function castToStage(value: any): Stage?
   return if value == "self" or value == "ancestor" or value == "descendants" or value == "observer" then value else nil
end

local function castToKey(value: any): Types.SpecialKey?
   return if typeof(value) == "table"
         and value.type == "SpecialKey"
         and typeof(value.kind) == "string"
         and castToStage(value.stage)
         and typeof(value.apply) == "function"
      then value
      else nil
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
         if not castToKey(k) then
            return Runtime.throwError("unrecognizedSpecialKey", nil, "[BatchKeys]")
         end
         k:apply(scope, value, instance)
      end
   end

   keyCache[stage] = specialKey
   table.freeze(specialKey)
   return specialKey
end

return BatchKeys
