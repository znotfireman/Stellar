--[[
	Handles interaction with the Fusion library. Provides access to Fusion's
	constructors and types, and manages initialization based on the environment.
]]

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Logging
local parseError = require("@src/Logging/parseError")
-- Utility
local Result = require("@src/Utility/Result")

local FUSION_LOCATIONS = table.freeze {
	"../Fusion",
	"../fusion",
	"./Packages/Fusion",
	"./Packages/fusion",
	"./vendor/Fusion",
	"./vendor/fusion",
}

local FUSION_TYPES = table.freeze {
	version = "table",
	Contextual = "function",
	Safe = "function",

	deriveScope = "function",
	doCleanup = "function",
	innerScope = "function",
	scoped = "function",

	Observer = "function",

	Computed = "function",
	ForKeys = "function",
	ForPairs = "function",
	ForValues = "function",
	peek = "function",
	Value = "function",

	Attribute = "function",
	AttributeChange = "function",
	AttributeOut = "function",
	Children = "function",
	Hydrate = "function",
	New = "function",
	OnChange = "function",
	OnEvent = "function",
	Out = "function",
	Ref = "function",

	Tween = "function",
	Spring = "function",
}

local Fusion = {}

local currentInstallation: Types.Fusion? = nil

local function castToFusion(value: any): Types.Result<Types.Fusion>
	if typeof(value) ~= "table" then
		return Result.err("expected a table of exports")
	end
	local exports = value :: Types.Fusion
	local version = exports.version
	if typeof(version) ~= "table" then
		return Result.err("malformed Fusion version")
	end
	local major, minor = tonumber(version.major) or 0, tonumber(version.minor) or 0
	if minor < 3 then
		return Result.err(`incompatible version {major}.{minor}, Stellar requires at minimum Fusion 0.3`)
	end
	for key, expectedType in pairs(FUSION_TYPES) do
		if not exports[key] then
			return Result.err(`cannot find {key} in Fusion exports`)
		end
		local realType = typeof(key)
		if realType ~= expectedType then
			return Result.err(`expected {key} to be a {expectedType}, got {realType}`)
		end
	end
	return Result.ok(value)
end

function Fusion.setInstallation(newInstallation: Types.Fusion): Types.Result<Types.Fusion?>
	local result = castToFusion(newInstallation)
	if not result.ok then
		return Result.err(result.reason)
	end
	local oldInstallation = currentInstallation
	currentInstallation = newInstallation
	if oldInstallation then
		for key in pairs(oldInstallation) do
			rawset(Fusion, key, nil)
		end
	end
	for key, value in pairs(newInstallation) do
		rawset(Fusion, key, value)
	end
	return Result.ok(oldInstallation)
end

function Fusion.findInstallation(mode: "roblox" | "lune"): Types.Fusion?
	if mode == "roblox" then
		local ancestor: Instance?, fusion: ModuleScript = script, nil
		while ancestor do
			local found = ancestor:FindFirstChild("Fusion") or ancestor:FindFirstChild("fusion")
			if found and found:IsA("ModuleScript") then
				fusion = found
				break
			end
			ancestor = ancestor.Parent
		end
		local ok, exports = xpcall(require, parseError, fusion)
		if not ok then
			Runtime.throwError("invalidFusionInstallation", exports, "failed to require, ERROR_MESSAGE")
		end
		return if castToFusion(exports).ok then exports else nil
	elseif mode == "lune" then
		for _, path in ipairs(FUSION_LOCATIONS) do
			local _, exports = pcall(require, path)
			if castToFusion(exports).ok then
				return exports
			end
		end
	end
	return nil
end

function Fusion.hasInstallation(): boolean
	return currentInstallation ~= nil
end

setmetatable(Fusion, {
	__index = function(): never
		return Runtime.throwError("noFusionInstallation")
	end,
})
return (Fusion :: any) :: Types.Fusion & typeof(Fusion)
