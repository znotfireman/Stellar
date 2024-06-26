local Result = require("@src/Utility/Result")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
local parseError = require("@src/Utility/parseError")

export type Animatable = Types.Animatable
export type Child = Types.Child
export type Computed<T> = Types.Computed<T>
export type Contextual<T> = Types.Contextual<T>
export type For<KO, VO> = Types.For<KO, VO>
export type Fusion = Types.Fusion
export type GraphObject = Types.GraphObject
export type Observer = Types.Observer
export type PropertyTable = Types.PropertyTable
export type Scope<Constructors> = Types.Scope<Constructors>
export type ScopedObject = Types.ScopedObject
export type SpecialKey = Types.SpecialKey
export type Spring<T> = Types.Spring<T>
export type StateObject<T> = Types.StateObject<T>
export type Task = Types.Task
export type Tween<T> = Types.Tween<T>
export type Use = Types.Use
export type UsedAs<T> = Types.UsedAs<T>
export type Value<T, S = T> = Types.Value<T, S>
export type Version = Types.Version

local FUSION_LOCATIONS = table.freeze {
   "../Fusion",
   "../fusion",
   "./Packages/Fusion",
   "./Packages/fusion",
   "./vendor/Fusion",
   "./vendor/fusion",
}
local FUSION_TYPES = table.freeze {
   version = "table",
   Contextual = "function",
   Safe = "function",

   deriveScope = "function",
   doCleanup = "function",
   innerScope = "function",
   scoped = "function",

   Observer = "function",

   Computed = "function",
   ForKeys = "function",
   ForPairs = "function",
   ForValues = "function",
   peek = "function",
   Value = "function",

   Attribute = "function",
   AttributeChange = "function",
   AttributeOut = "function",
   Children = "function",
   Hydrate = "function",
   New = "function",
   OnChange = "function",
   OnEvent = "function",
   Out = "function",
   Ref = "function",

   Tween = "function",
   Spring = "function",
}

local Fusion = {}

local currentInstallation: Types.Fusion? = nil

local function isFusion(value: any): (boolean, string)
   if typeof(value) ~= "table" then
      return false, "expected a table of exports"
   end
   local exports = value :: Types.Fusion
   local version = exports.version
   if typeof(version) ~= "table" then
      return false, "malformed Fusion version"
   end
   local major, minor = tonumber(version.major) or 0, tonumber(version.minor) or 0
   if minor < 3 then
      return false, ("incompatible version %d.%d, Stellar requires at minimum Fusion 0.3"):format(major, minor)
   end
   for key, expectedType in pairs(FUSION_TYPES) do
      if not exports[key] then
         return false, ("cannot find %s in Fusion exports"):format(key)
      end
      local realType = typeof(key)
      if realType ~= expectedType then
         return false, ("expected %s to be a %s, got %s"):format(key, expectedType, realType)
      end
   end
   return true, "success"
end

function Fusion.setInstallation(newInstallation: Types.Fusion): Result.Result<Types.Fusion?>
   local isFusion, reason = isFusion(newInstallation)
   if not isFusion then
      return Result.err(reason)
   end
   local oldInstallation = currentInstallation
   currentInstallation = newInstallation
   if oldInstallation then
      for key in pairs(oldInstallation) do
         Fusion[key] = nil
      end
   end
   for key, value in pairs(newInstallation) do
      Fusion[key] = value
   end
   return Result.ok(oldInstallation)
end

function Fusion.tryDiscoverInstallation(mode: "roblox" | "lune"): Types.Fusion?
   if mode == "roblox" then
      local ancestor: Instance?, fusion: ModuleScript = script, nil
      while ancestor do
         local found = ancestor:FindFirstChild("Fusion") or ancestor:FindFirstChild("fusion")
         if found and found:IsA("ModuleScript") then
            fusion = found
            break
         end
         ancestor = ancestor.Parent
      end
      local ok, exports = xpcall(require, parseError, fusion)
      if not ok then
         Runtime.throwError("invalidFusionInstallation", exports, "failed to require, ERROR_MESSAGE")
      end
      return if isFusion(exports) then exports else nil
   elseif mode == "lune" then
      for _, path in ipairs(FUSION_LOCATIONS) do
         local _, exports = pcall(require, path)
         if isFusion(exports) then
            return exports
         end
      end
   end
   return nil
end

function Fusion.hasInstallation(): boolean
   return currentInstallation ~= nil
end

return (Fusion :: any) :: Types.Fusion & {
   hasInstallation: () -> boolean,
   setInstallation: ((newInstallation: Types.Fusion) -> (true, Types.Fusion?))
      & ((newInstallation: Types.Fusion) -> (false, string)),
   tryDiscoverInstallation: (mode: "roblox" | "lune") -> Types.Fusion?,
}
