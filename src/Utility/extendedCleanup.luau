--[[
   Extended `doCleanup()`, also accepts signal-like objects, promises, threads
   and objects with disconnect methods.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

type Connection = { Connected: boolean, Disconnect: (self: Connection) -> () }
type Promise = { getStatus: (self: any) -> string, cancel: (self: any) -> () }

local DESTRUCTORS = table.freeze { "destroy", "Destroy", "disconnect", "Disconnect" }

local alreadyDestroying: { [Types.Task]: true } = {}

local function castToConnection(value: any): Connection
   return if typeof(value) == "table"
         and typeof(value.Connected) == "boolean"
         and typeof(value.Disconnect) == "function"
      then value
      else nil
end

local function castToPromise(value: any): Promise
   return if typeof(value) == "table"
         and typeof(value.getStatus) == "function"
         and typeof(value.cancel) == "function"
      then value
      else nil
end

local function tryCleanupOne(job: Types.Task)
   if alreadyDestroying[job] then
      Runtime.throwError("destroyedTwice")
   end
   alreadyDestroying[job] = true

   if typeof(job) == "Instance" then
      -- Case 1: instances
      local instance = job :: Instance
      instance:Destroy()
   elseif typeof(job) == "RBXScriptConnection" or castToConnection(job) then
      -- Case 2: script connections
      local connection: Connection = job :: any
      connection:Disconnect()
   elseif typeof(job) == "function" then
      -- Case 3: callbacks
      local callback = job :: () -> ()
      callback()
   elseif typeof(job) == "thread" then
      -- Case 4: threads
      local thread = job :: thread
      local cancelled = false
      if coroutine.running() ~= thread then
         cancelled = pcall(Runtime.cancelTask, thread)
      end
      if not cancelled then
         Runtime.deferTask(Runtime.cancelTask, thread)
      end
   elseif castToPromise(job) then
      -- Case 5: promises
      local promise = job :: Promise
      if promise:getStatus() == "Started" then
         promise:cancel()
      end
   elseif typeof(job) == "table" then
      local table = job :: { [any]: any }
      local isDestroyed = false
      for _, method in ipairs(DESTRUCTORS) do
         local destructor = table[method] :: () -> ()
         if typeof(destructor) == "function" then
            -- Case 6: custom objects
            destructor()
            isDestroyed = true
            break
         end
      end
      if not isDestroyed and table[1] ~= nil then
         -- Case 7: scopes
         local scope = table :: Types.Scope<unknown>
         for _, subtask in ipairs(scope) do
            tryCleanupOne(subtask :: any)
         end
         -- Let Fusion poison the scope itself
         Fusion.doCleanup(scope)
         getmetatable(scope :: any).__stellarPoisoned = true
      end
   end

   alreadyDestroying[job] = nil
end

local function extendedCleanup(...: Types.Task)
   for _, job in ipairs { ... } do
      tryCleanupOne(job)
   end
end

return extendedCleanup
