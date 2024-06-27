--[[
   Variant of the built-in Children special key with support for unresolved
   child, allowing users to hydrate children more ergonomically.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- State
local castToState = require("@src/State/castToState")
-- Utility
local extendedCleanup = require("@src/Utility/extendedCleanup")
local xtypeof = require("@src/Utility/xtypeof")

type Set<T> = { [T]: true }

local EXPERIMENTAL_AUTO_NAMING = true
local WAIT_WARNING_THRESHOLD = 8

local function castToUnresolvedChild(value: any): Types.UnresolvedChild?
   return if typeof(value) == "table"
         and value.type == "UnresolvedChild"
         and (value.mode == "WaitForChild" or value.mode == "FindFirstChild")
         and typeof(value.name) == "string"
         and typeof(value.props) == "table"
      then value
      else nil
end

local Children = {} :: Types.SpecialKey
Children.type = "SpecialKey"
Children.kind = "Stellar.Children"
Children.stage = "descendants"

function Children:apply(scope, value, instance)
   local newParented: Set<Instance> = {}
   local oldParented: Set<Instance> = {}

   local newScopes: { [Types.StateObject<unknown>]: Types.Scope<unknown> } = {}
   local oldScopes: { [Types.StateObject<unknown>]: Types.Scope<unknown> } = {}

   local function updateChildren()
      oldParented, newParented = newParented, oldParented
      oldScopes, newScopes = newScopes, oldScopes

      local function processChild(child: unknown, autoName: string?)
         if typeof(child) == "Instance" then
            -- Case 1: single instance
            newParented[child] = true
            if EXPERIMENTAL_AUTO_NAMING and autoName ~= nil then
               child.Name = autoName
            end
            if oldParented[child] == nil then
               -- TODO: check for ancestry conflicts here
               child.Parent = instance
            else
               oldParented[child] = nil
            end
            return
         elseif castToState(child) then
            -- Case 2: state object
            local child = child :: Types.StateObject<unknown>
            local value = Fusion.peek(child)
            if value ~= nil then
               processChild(value, autoName)
            end
            local childScope = oldScopes[child]
            if childScope == nil then
               childScope = {}
               Fusion.Observer(childScope, child):onChange(updateChildren)
            else
               oldScopes[child] = nil
            end
            newScopes[child] = childScope
            return
         elseif castToUnresolvedChild(child) then
            -- Case 3: unresolved child
            local child = child :: Types.UnresolvedChild
            local foundChild: Instance? = nil
            if child.mode == "FindFirstChild" then
               foundChild = instance:FindFirstChild(child.name)
            elseif child.mode == "WaitForChild" then
               if Runtime.isTimeCritical() then
                  return Runtime.throwError("cannotYield", nil, "a time critical piece of code")
               end
               local warnThread = Runtime.delayTask(WAIT_WARNING_THRESHOLD * Runtime.safetyTimeMultiplier, function()
                  if not foundChild then
                     Runtime.throwWarning("childInfiniteYield", child.name, instance.Name)
                  end
               end)
               -- math.huge as timeout so we can warn instead of Roblox
               foundChild = instance:WaitForChild(child.name, math.huge)
               if warnThread then
                  Runtime.cancelTask(warnThread)
               end
            end
            if not foundChild then
               return Runtime.throwError("cannotFindUnresolvedChild", nil, child.name, instance.Name)
            end
            Fusion.Hydrate(scope, foundChild)(child.props)
            newParented[foundChild] = true
            oldParented[foundChild] = nil
         elseif typeof(child) == "table" then
            -- Case 4: table of objects
            local child = child :: { [unknown]: unknown }
            for key, subChild in pairs(child) do
               local keyType = typeof(key)
               local subAutoName: string? = nil
               if keyType == "string" then
                  local key = key :: string
                  subAutoName = key
               elseif keyType == "number" and autoName ~= nil then
                  local key = key :: number
                  subAutoName = autoName .. "_" .. key
               end
               processChild(subChild, subAutoName)
            end
            return
         end
         Runtime.throwWarning("unrecognizedChildType", xtypeof(child))
      end
      if value ~= nil then
         processChild(value)
      end
      for oldInstance in pairs(oldParented) do
         oldInstance.Parent = nil
      end
      table.clear(oldParented)
      for oldState, childScope in pairs(oldScopes) do
         extendedCleanup(childScope :: any)
      end
      table.clear(oldScopes)
   end
   table.insert(scope, function()
      value = nil
      updateChildren()
   end)
   updateChildren()
end

table.freeze(Children)
return Children
