--[[

]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

local function computeFromInstance<Returns, Args...>(
   scope: Types.Scope<any>,
   computation: (
      scope: Types.Scope<any>,
      instance: Instance,
      Args...
   ) -> Returns,
   instance: Instance,
   ...: Args...
): Types.UsedAs<Returns>
   if typeof(instance) == "Instance" then
      return computation(scope, instance, ...)
   end
   local arguments = table.pack(...)
   local computed = Fusion.Computed(scope, function(use, scope)
      return use(computation(scope, use(instance), table.unpack(arguments :: any)))
   end)
   return computed
end

return computeFromInstance
