--[[
	Packages up the internal of Stellar and exposes an API for it. Connects to
	Fusion if it finds one.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

do
	-- Down the line, this will be conditional based on what runtime Stellar
	-- is compiled for.
	local RobloxRuntime = require("@src/RobloxRuntime")
	Runtime.setProvider(RobloxRuntime)
	local result = Fusion.setInstallation(Fusion.findInstallation("roblox") :: any)
	if not result.ok then
		Runtime.throwError("invalidFusionInstallation", nil, result.reason)
	end
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

	Observe: Types.ObserveConstructor,
	ObserveBind: Types.ObserveConstructor,
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
	AttributesOf: Types.AttributesSelector,
	AttributeNamed: Types.AttributeSelector,
	BindAttribute: Types.BindAttributeSelector,
	HasAttribute: Types.HasAttributeSelector,
	ChildrenOf: Types.InstancesSelector,
	DescendantsOf: Types.InstancesSelector,

	extendedCleanup: (...Task) -> (),

	scopable: {
		Observe: Types.ObserveConstructor,
		ObserveBind: Types.ObserveConstructor,

		Derive: Types.DeriveConstructor,

		AncestorNamed: Types.NameSelector,
		AncestorOfClass: Types.ClassNameSelector,
		AncestorWhichIsA: Types.ClassNameSelector,
		AncestorsOf: Types.InstancesSelector,
		AttributesOf: Types.AttributesSelector,
		AttributeNamed: Types.AttributeSelector,
		BindAttribute: Types.BindAttributeSelector,
		HasAttribute: Types.HasAttributeSelector,
		ChildrenOf: Types.InstancesSelector,
		DescendantsOf: Types.InstancesSelector,

		expandedCleanup: (...Task) -> (),
	},
}

local Stellar: Stellar = table.freeze {
	version = { major = 0, minor = 1, patch = 0 },
	setInstallation = Fusion.setInstallation,
	setProvider = Runtime.setProvider,

	Observe = require("@src/State/Observe"),
	ObserveBind = require("@src/State/ObserveBind"),
	flatten = require("@src/State/flatten"),

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
	AttributesOf = require("@src/Instances/AttributesOf"),
	AttributeNamed = require("@src/Instances/AttributeNamed"),
	BindAttribute = require("@src/Instances/BindAttribute"),
	HasAttribute = require("@src/Instances/HasAttribute"),
	ChildrenOf = require("@src/Instances/ChildrenOf"),
	DescendantsOf = require("@src/Instances/DescendantsOf"),

	extendedCleanup = require("@src/Utility/extendedCleanup"),

	scopable = table.freeze {
		Derive = require("@src/Instances/Derive"),

		AncestorNamed = require("@src/Instances/AncestorNamed"),
		AncestorOfClass = require("@src/Instances/AncestorOfClass"),
		AncestorWhichIsA = require("@src/Instances/AncestorWhichIsA"),
		AncestorsOf = require("@src/Instances/AncestorsOf"),
		AttributesOf = require("@src/Instances/AttributesOf"),
		AttributeNamed = require("@src/Instances/AttributeNamed"),
		BindAttribute = require("@src/Instances/BindAttribute"),
		HasAttribute = require("@src/Instances/HasAttribute"),
		ChildrenOf = require("@src/Instances/ChildrenOf"),
		DescendantsOf = require("@src/Instances/DescendantsOf"),

		Observe = require("@src/State/Observe"),
		ObserveBind = require("@src/State/ObserveBind"),

		expandedCleanup = require("@src/Utility/extendedCleanup"),
	},

	unstable = table.freeze({}),
}

return Stellar
