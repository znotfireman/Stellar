local FusionTypes = require("@src/FusionTypes")

export type Animatable = FusionTypes.Animatable
export type Child = FusionTypes.Child
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

export type RuntimeProvider = {
   policies: {
      allowWebLinks: boolean,
   },

   startScheduler: () -> (),
   stopScheduler: () -> (),

   cancelTask: (job: thread) -> (),
   deferTask: <A...>(job: (A...) -> () | thread, A...) -> thread,
   spawnTask: <A...>(job: (A...) -> () | thread, A...) -> thread,

   throwErrorNonFatal: (messageString: string) -> (),
   throwWarning: (messageString: string) -> (),
}

export type Version = {
   major: number,
   minor: number,
   patch: number,
}

return {}
