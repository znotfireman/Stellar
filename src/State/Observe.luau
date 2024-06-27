--[[
   Constructs Observers watching state objects, returns a callback to unbind
   aforementioned Observers.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
local castToState = require("@src/State/castToState")

local function Observe(
   scope: Types.Scope<any>,
   watching: Types.StateObject<any> | { Types.StateObject<any> },
   callback: () -> ()
): () -> ()
   if castToState(watching) then
      return Fusion.Observer(scope, watching):onChange(callback)
   end
   if typeof(watching) ~= "table" then
      return Runtime.throwError("invalidStateObject", nil, typeof(watching), "Observe()")
   end
   local disconnectFns: { () -> () } = {}
   for _, stateObject in ipairs(watching) do
      if not castToState(stateObject) then
         return Runtime.throwError("invalidStateObject", nil, typeof(watching), "Observe()")
      end
      table.insert(disconnectFns, Fusion.Observer(scope, watching):onChange(callback))
   end
   local connected = false
   local function unbind(): ()
      if not connected then
         return Runtime.throwError("unbindedTwice", nil, "bounded observers")
      end
      connected = false
      for _, disconnect in ipairs(disconnectFns) do
         disconnect()
      end
      table.clear(disconnectFns)
   end
   return unbind
end

return Observe
