--[[
   Entry point for the Stellar library.
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
	if not Fusion.hasInstallation() then
		Runtime.throwError("noFusionInstallation")
	end
end

local AncestorsOf = require("@src/Instances/AncestorsOf")
local Apply = require("@src/Instances/Apply")
local AttributesOf = require("@src/Instances/AttributesOf")
local BatchKeys = require("@src/Instances/BatchKeys")
local Children = require("@src/Instances/Children")
local ChildrenOf = require("@src/Instances/ChildrenOf")
local Cleanup = require("@src/Instances/Cleanup")
local Default = require("@src/Instances/Default")
local Derive = require("@src/Instances/Derive")
local DescendantsOf = require("@src/Instances/DescendantsOf")
local Observe = require("@src/State/Observe")
local ObserveBind = require("@src/State/ObserveBind")
local WaitChild = require("@src/Instances/WaitChild")
local WithChild = require("@src/Instances/WithChild")
local extendedCleanup = require("@src/Utility/extendedCleanup")
local flatten = require("@src/State/flatten")

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
	Children: Types.SpecialKey,
	Cleanup: Types.SpecialKey,
	Default: Types.DefaultKeyConstructor,
	Derive: Types.DeriveConstructor,
	WaitChild: Types.UnresolvedChildConstructor,
	WithChild: Types.UnresolvedChildConstructor,

	AncestorsOf: Types.InstancesSelector,
	AttributesOf: Types.AttributesSelector,
	ChildrenOf: Types.InstancesSelector,
	DescendantsOf: Types.InstancesSelector,

	extendedCleanup: (...Task) -> (),

	scopable: {
		Observe: Types.ObserveConstructor,
		ObserveBind: Types.ObserveConstructor,

		Derive: Types.DeriveConstructor,

		AncestorsOf: Types.InstancesSelector,
		AttributesOf: Types.AttributesSelector,
		ChildrenOf: Types.InstancesSelector,
		DescendantsOf: Types.InstancesSelector,

		expandedCleanup: (...Task) -> (),
	},
}

local Stellar: Stellar = table.freeze {
	version = table.freeze { major = 0, minor = 1, patch = 0 },
	setInstallation = Fusion.setInstallation,
	setProvider = Runtime.setProvider,

	Observe = Observe,
	ObserveBind = ObserveBind,
	flatten = flatten,

	Apply = Apply,
	BatchKeys = BatchKeys,
	Children = Children,
	Cleanup = Cleanup,
	Default = Default,
	Derive = Derive,
	WaitChild = WaitChild,
	WithChild = WithChild,

	AncestorsOf = AncestorsOf,
	AttributesOf = AttributesOf,
	ChildrenOf = ChildrenOf,
	DescendantsOf = DescendantsOf,

	extendedCleanup = extendedCleanup,

	-- Methods designed to use scoped() syntax
	scopable = table.freeze {
		Derive = Derive,

		AncestorsOf = AncestorsOf,
		AttributesOf = AttributesOf,
		ChildrenOf = ChildrenOf,
		DescendantsOf = DescendantsOf,

		Observe = Observe,
		ObserveBind = ObserveBind,

		expandedCleanup = extendedCleanup,
	},
}
