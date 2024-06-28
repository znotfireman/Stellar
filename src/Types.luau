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
		enableWebLinks: boolean,
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

export type Symbol<kind = string> = {
	type: "Symbol",
	kind: kind,
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
   | Scope<any>
   | (...any) -> ...any
   | { [unknown]: Task }
   | { destroy: (self: any) -> () }
   | { Destroy: (self: any) -> () }
   | { disconnect: (self: any) -> () }
   | { Disconnect: (self: any) -> () }
   | { Connected: boolean, Disconnect: (self: any) -> () }
   | { getStatus: (self: any) -> string, cancel: (self: any) -> () }

--[[
	State object related types
]]

export type EventualConstructor = <T, S>(
	scope: Scope<any> & S,
	initialValue: T,
	computation: (become: <T>(target: T) -> T, use: Use, scope: Scope<any> & S) -> T
) -> StateObject<T>

export type FreezeConstructor = <T>(
	scope: Scope<any>,
	target: StateObject<T>,
	isFrozen: StateObject<boolean>
) -> StateObject<T>

export type ObserveConstructor = (
	scope: Scope<any>,
	watching: StateObject<any> | { StateObject<any> },
	callback: () -> ()
) -> () -> ()

export type SwitchConstructor = <Options, Result>(
	scope: Scope<any>,
	target: StateObject<Options>,
	options: { [Options | { type: "Symbol", kind: "SwitchDefault" }]: () -> Result }
) -> StateObject<Result>

export type ToggleConstructor = <Default, Fallback>(
	scope: Scope<any>,
	target: StateObject<any>,
	options: {
		show: () -> Default,
		fallback: (() -> Fallback)?,
	}
) -> StateObject<Default | Fallback>

--[[
	Instance related types
]]

export type Child = Instance | StateObject<Child> | UnresolvedChild | { Child }

type DefaultKey = { type: "DefaultKey", prop: string }
export type DefaultKeyConstructor = (propertyName: string) -> DefaultKey

export type DeriveConstructor = <T>(scope: Scope<any>, template: T & Instance) -> (propertyTable: PropertyTable) -> T

export type UnresolvedChild = {
	type: "UnresolvedChild",
	mode: "WaitForChild" | "FindFirstChild",
	name: string,
	props: PropertyTable,
}
export type UnresolvedChildConstructor = (childName: string) -> (properties: PropertyTable) -> UnresolvedChild

export type AttributeSelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance>,
	attributeName: string
) -> StateObject<any>

export type AttributesSelector = (scope: Scope<any>, instance: UsedAs<Instance>) -> StateObject<{ [string]: any }>

export type BindAttributeSelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance?>,
	attributeName: string,
	value: any
) -> () -> ()

export type BindPropertySelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance?>,
	propertyName: string,
	value: any
) -> () -> ()

export type ClassNameSelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance>,
	className: string
) -> StateObject<Instance?>

export type HasAttributeSelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance>,
	attributeName: string
) -> StateObject<boolean>

export type InstancesSelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance>
) -> StateObject<{ [number]: Instance }>

export type NameSelector = (scope: Scope<any>, instance: UsedAs<Instance>, name: string) -> StateObject<Instance?>

export type PropertySelector = (
	scope: Scope<any>,
	instance: UsedAs<Instance?>,
	propertyName: string
) -> StateObject<any>

-- stylua: ignore
export type TagSelector = (
   scope: Scope<any>,
   instance: UsedAs<Instance>
) -> StateObject<{ string }>

--[[
	Animation related types
]]

export type KeyframesConstructor = <T>(
	scope: Scope<any>,
	currentTime: StateObject<number>,
	keyframes: { [number]: T }
) -> StateObject<T>

return {}
