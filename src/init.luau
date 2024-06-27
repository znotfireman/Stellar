--[[
	Packages up the internal of Stellar and exposes an API for it. Connects to
	Fusion if it finds a valid installation.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Symbols = require("@src/Utility/Symbols")
local Types = require("@src/Types")

do
	-- Down the line, this will be conditional based on what runtime Stellar is
	-- compiled for.
	local RobloxRuntime = require("@src/RobloxRuntime")
	Runtime.setProvider(RobloxRuntime)
	local result = Fusion.setInstallation(Fusion.findInstallation("roblox") :: any)
	if not result.ok then
		Runtime.throwError("invalidFusionInstallation", nil, result.reason)
	end

	local function inlineTest(): string
		return debug.info(1, "n")
	end
	local isO2 = inlineTest() ~= "inlineTest"
	Runtime.setStrictMode(not isO2)
end

export type Child = Types.Child
export type Result<T> = Types.Result<T>
export type RuntimeProvider = Types.RuntimeProvider
export type Task = Types.Task
export type UnresolvedChild = Types.UnresolvedChild
export type Version = Types.Version

type Stellar = {
	version: Version,
	setInstallation: (newInstallation: Types.Fusion) -> Result<Types.Fusion?>,
	setProvider: (newProvider: RuntimeProvider) -> RuntimeProvider?,
	setStrictMode: (newValue: boolean) -> (),

	Freeze: Types.FreezeConstructor,
	Observe: Types.ObserveConstructor,
	ObserveBind: Types.ObserveConstructor,
	ReadOnly: <T>(scope: Types.Scope<any>, target: Types.StateObject<T>) -> Types.StateObject<T>,
	Switch: Types.SwitchConstructor,
	Toggle: Types.ToggleConstructor,
	flatten: (target: Types.UsedAs<any>, use: Types.Use?) -> any,

	Apply: Types.SpecialKey,
	BatchKeys: (stage: "self" | "ancestor" | "descendants" | "observer") -> Types.SpecialKey,
	Child: (child: { Types.Child }) -> Types.Child,
	Children: Types.SpecialKey,
	Cleanup: Types.SpecialKey,
	Default: Types.DefaultKeyConstructor,
	Derive: Types.DeriveConstructor,
	WaitChild: Types.UnresolvedChildConstructor,
	WithChild: Types.UnresolvedChildConstructor,

	AncestorNamed: Types.NameSelector,
	AncestorOfClass: Types.ClassNameSelector,
	AncestorWhichIsA: Types.ClassNameSelector,
	AncestorsOf: Types.InstancesSelector,
	AttributeNamed: Types.AttributeSelector,
	AttributesOf: Types.AttributesSelector,
	BindAttribute: Types.BindAttributeSelector,
	HasAttribute: Types.HasAttributeSelector,
	ChildrenOf: Types.InstancesSelector,
	DescendantNamed: Types.NameSelector,
	DescendantOfClass: Types.ClassNameSelector,
	DescendantWhichIsA: Types.ClassNameSelector,
	DescendantsOf: Types.InstancesSelector,
	BindProperty: Types.BindPropertySelector,
	PropertyOf: Types.PropertySelector,

	extendedCleanup: (...Task) -> (),

	Keyframes: Types.KeyframesConstructor,

	scopable: {
		Freeze: Types.FreezeConstructor,
		Observe: Types.ObserveConstructor,
		ObserveBind: Types.ObserveConstructor,
		ReadOnly: <T>(scope: Types.Scope<any>, target: Types.StateObject<T>) -> Types.StateObject<T>,
		Switch: Types.SwitchConstructor,
		Toggle: Types.ToggleConstructor,

		Derive: Types.DeriveConstructor,

		AncestorNamed: Types.NameSelector,
		AncestorOfClass: Types.ClassNameSelector,
		AncestorWhichIsA: Types.ClassNameSelector,
		AncestorsOf: Types.InstancesSelector,
		AttributeNamed: Types.AttributeSelector,
		AttributesOf: Types.AttributesSelector,
		BindAttribute: Types.BindAttributeSelector,
		HasAttribute: Types.HasAttributeSelector,
		ChildNamed: Types.NameSelector,
		ChildOfClass: Types.ClassNameSelector,
		ChildWhichIsA: Types.ClassNameSelector,
		ChildrenOf: Types.InstancesSelector,
		DescendantNamed: Types.NameSelector,
		DescendantOfClass: Types.ClassNameSelector,
		DescendantWhichIsA: Types.ClassNameSelector,
		DescendantsOf: Types.InstancesSelector,
		BindProperty: Types.BindPropertySelector,
		PropertyOf: Types.PropertySelector,

		expandedCleanup: (...Task) -> (),

		Keyframes: Types.KeyframesConstructor,
	},
}

local Stellar: Stellar = table.freeze {
	-- General
	version = { major = 0, minor = 1, patch = 0 },
	setInstallation = Fusion.setInstallation,
	setProvider = Runtime.setProvider,
	setStrictMode = Runtime.setStrictMode,

	-- State
	Freeze = require("@src/State/Freeze"),
	Observe = require("@src/State/Observe"),
	ObserveBind = require("@src/State/ObserveBind"),
	ReadOnly = require("@src/State/ReadOnly"),
	Switch = require("@src/State/Switch"),
	Toggle = require("@src/State/Toggle"),
	flatten = require("@src/State/flatten"),

	-- Instances
	Apply = require("@src/Instances/Apply"),
	BatchKeys = require("@src/Instances/BatchKeys"),
	Child = require("@src/Instances/Child"),
	Children = require("@src/Instances/Children"),
	Cleanup = require("@src/Instances/Cleanup"),
	Default = require("@src/Instances/Default"),
	Derive = require("@src/Instances/Derive"),
	WaitChild = require("@src/Instances/WaitChild"),
	WithChild = require("@src/Instances/WithChild"),

	AncestorNamed = require("@src/Instances/AncestorNamed"),
	AncestorOfClass = require("@src/Instances/AncestorOfClass"),
	AncestorWhichIsA = require("@src/Instances/AncestorWhichIsA"),
	AncestorsOf = require("@src/Instances/AncestorsOf"),
	AttributeNamed = require("@src/Instances/AttributeNamed"),
	AttributesOf = require("@src/Instances/AttributesOf"),
	BindAttribute = require("@src/Instances/BindAttribute"),
	HasAttribute = require("@src/Instances/HasAttribute"),
	ChildNamed = require("@src/Instances/ChildNamed"),
	ChildOfClass = require("@src/Instances/ChildOfClass"),
	ChildWhichIsA = require("@src/Instances/ChildWhichIsA"),
	ChildrenOf = require("@src/Instances/ChildrenOf"),
	DescendantNamed = require("@src/Instances/DescendantNamed"),
	DescendantOfClass = require("@src/Instances/DescendantOfClass"),
	DescendantWhichIsA = require("@src/Instances/DescendantWhichIsA"),
	DescendantsOf = require("@src/Instances/DescendantsOf"),
	BindProperty = require("@src/Instances/BindProperty"),
	PropertyOf = require("@src/Instances/PropertyOf"),

	-- Utility
	extendedCleanup = require("@src/Utility/extendedCleanup"),

	-- Animation
	Keyframes = require("@src/Animation/Keyframes"),

	scopable = table.freeze {
		-- State
		Freeze = require("@src/State/Freeze"),
		Observe = require("@src/State/Observe"),
		ObserveBind = require("@src/State/ObserveBind"),
		ReadOnly = require("@src/State/ReadOnly"),
		Switch = require("@src/State/Switch"),
		Toggle = require("@src/State/Toggle") :: Types.ToggleConstructor,

		-- Instances
		Derive = require("@src/Instances/Derive"),

		AncestorNamed = require("@src/Instances/AncestorNamed"),
		AncestorOfClass = require("@src/Instances/AncestorOfClass"),
		AncestorWhichIsA = require("@src/Instances/AncestorWhichIsA"),
		AncestorsOf = require("@src/Instances/AncestorsOf"),
		AttributeNamed = require("@src/Instances/AttributeNamed"),
		AttributesOf = require("@src/Instances/AttributesOf"),
		BindAttribute = require("@src/Instances/BindAttribute"),
		HasAttribute = require("@src/Instances/HasAttribute"),
		ChildNamed = require("@src/Instances/ChildNamed"),
		ChildOfClass = require("@src/Instances/ChildOfClass"),
		ChildWhichIsA = require("@src/Instances/ChildWhichIsA"),
		ChildrenOf = require("@src/Instances/ChildrenOf"),
		DescendantNamed = require("@src/Instances/DescendantNamed"),
		DescendantOfClass = require("@src/Instances/DescendantOfClass"),
		DescendantWhichIsA = require("@src/Instances/DescendantWhichIsA"),
		DescendantsOf = require("@src/Instances/DescendantsOf"),
		BindProperty = require("@src/Instances/BindProperty"),
		PropertyOf = require("@src/Instances/PropertyOf"),

		-- Utility
		expandedCleanup = require("@src/Utility/extendedCleanup"),

		-- Animation
		Keyframes = require("@src/Animation/Keyframes"),
	},

	unstable = table.freeze({}),
}

return Stellar
