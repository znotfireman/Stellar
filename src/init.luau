--------------------------------------------------------------------------------
-- Stellar.luau
-- v0.1.0
--------------------------------------------------------------------------------

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

do
   local fusionExports: Types.Fusion? = nil
   local runtime = Runtime.detectRuntime()
   if _G.STELLAR_COMPILE_TARGET == "roblox" or runtime == "roblox" then
      local RobloxRuntime = require("@src/Runtime/RobloxRuntime")
      Runtime.setProvider(RobloxRuntime)
   elseif _G.STELLAR_COMPILE_TARGET == "lune" or runtime == "lune" then
      local LuneRuntime = require("@src/Runtime/LuneRuntime")
      Runtime.setProvider(LuneRuntime)
   end
   fusionExports = Fusion.tryDiscoverInstallation(runtime :: any)
   local ok, reason = Fusion.setInstallation(fusionExports :: any)
   if not ok then
      Runtime.throwError("invalidFusionInstallation", nil, reason)
   end
   if not Fusion.hasInstallation() then
      Runtime.throwError("noFusionInstallation")
   end
end

local BatchKeys = require("@src/Instances/BatchKeys")
local deepfreeze = require("@src/Utility/deepfreeze")
local expandedCleanup = require("@src/Utility/expandedCleanup")

export type Task = Types.Task
export type Result<T> = Types.Result<T>
export type Version = Types.Version
export type RuntimeProvider = Types.RuntimeProvider

type Stellar = {
   version: Version,
   setInstallation: (newInstallation: Types.Fusion) -> Result<Types.Fusion?>,
   setProvider: (newProvider: RuntimeProvider) -> RuntimeProvider?,

   BatchKeys: (stage: "self" | "ancestor" | "descendants" | "observer") -> Types.SpecialKey,

   expandedCleanup: (...Task) -> (),

   scopable: {
      expandedCleanup: (...Task) -> (),
   },
}

return deepfreeze {
   version = { major = 0, minor = 1, patch = 0 },
   setInstallation = Fusion.setInstallation,
   setProvider = Runtime.setProvider,

   BatchKeys = BatchKeys,

   expandedCleanup = expandedCleanup,

   -- Methods designed to use scoped() syntax
   scopable = {
      expandedCleanup = expandedCleanup,
   },
} :: Stellar
