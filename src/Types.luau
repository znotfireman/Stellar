--[[
   Exports common type information for Stellar APIs as well reexports Fusion's
   own types for reusage.
]]

local FusionTypes = require("@src/FusionTypes")

export type Animatable = FusionTypes.Animatable
export type Computed<T> = FusionTypes.Computed<T>
export type Contextual<T> = FusionTypes.Contextual<T>
export type For<KO, VO> = FusionTypes.For<KO, VO>
export type Fusion = FusionTypes.Fusion
export type GraphObject = FusionTypes.GraphObject
export type Observer = FusionTypes.Observer
export type PropertyTable = FusionTypes.PropertyTable
export type Scope<Constructors> = FusionTypes.Scope<Constructors>
export type ScopedObject = FusionTypes.ScopedObject
export type SpecialKey = FusionTypes.SpecialKey
export type Spring<T> = FusionTypes.Spring<T>
export type StateObject<T> = FusionTypes.StateObject<T>
export type Tween<T> = FusionTypes.Tween<T>
export type Use = FusionTypes.Use
export type UsedAs<T> = FusionTypes.UsedAs<T>
export type Value<T, S = T> = FusionTypes.Value<T, S>

--[[
   General use types
]]

export type Error = {
   type: "Error",
   raw: string,
   message: string,
   trace: string,
}

export type Result<T> = {
   ok: true,
   value: T,
} | {
   ok: false,
   reason: string,
}

export type RuntimeProvider = {
   policies: {
      allowWebLinks: boolean,
   },

   startScheduler: () -> (),
   stopScheduler: () -> (),

   cancelTask: (job: thread) -> (),
   deferTask: <A...>(job: (A...) -> () | thread, A...) -> thread,
   delayTask: <A...>(delay: number, job: (A...) -> () | thread, A...) -> thread,
   spawnTask: <A...>(job: (A...) -> () | thread, A...) -> thread,

   throwErrorNonFatal: (messageString: string) -> (),
   throwWarning: (messageString: string) -> (),
}

export type Version = {
   major: number,
   minor: number,
   patch: number,
}

-- stylua: ignore
export type Task = never
   | Instance
   | RBXScriptConnection
   | thread
   | (...any) -> ...any
   | { [unknown]: Task }
   | { destroy: (self: any) -> () }
   | { Destroy: (self: any) -> () }
   | { disconnect: (self: any) -> () }
   | { Disconnect: (self: any) -> () }
   | { Connected: boolean, Disconnect: (self: any) -> () }
   | { getStatus: (self: any) -> string, cancel: (self: any) -> () }
   | FusionTypes.Scope<any>

--[[
   State object related types
]]

export type EventualConstructor<T, S> = (
   scope: Scope<any> & S,
   initialValue: T,
   computation: (become: <T>(target: T) -> T, use: Use, scope: Scope<any> & S) -> T
) -> StateObject<T>

export type ObserveConstructor = (
   scope: Scope<any>,
   watching: StateObject<any> | { StateObject<any> },
   callback: () -> ()
) -> () -> ()

--[[
   Instance related types
]]

export type Child = Instance | StateObject<Child> | UnresolvedChild | { Child }

export type UnresolvedChild = {
   type: "UnresolvedChild",
   mode: "WaitForChild" | "FindFirstChild",
   name: string,
   props: PropertyTable,
}
export type UnresolvedChildConstructor = (name: string) -> (properties: PropertyTable) -> UnresolvedChild

export type AttributeSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>,
   attribute: UsedAs<string>
) -> StateObject<any>

export type ClassNameSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>,
   className: string
) -> StateObject<Instance?>

export type InstancesSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>
) -> StateObject<{ [number]: Instance }>

export type NameSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>,
   name: string
) -> StateObject<Instance?>

export type PropertySelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>,
   property: UsedAs<string>
) -> StateObject<any>

-- stylua: ignore
export type TagSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>
) -> StateObject<{ string }>

return {}
