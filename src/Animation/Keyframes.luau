--[[
	Constructs and returns a state object that animates between keyframes based
	on current time with linear interpolation and clamping.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Animation
local Oklab = require("@src/Animation/Oklab")
local lerpType = require("@src/Animation/lerpType")
-- State
local ObserveBind = require("@src/State/ObserveBind")
local castToState = require("@src/State/castToState")
-- Utility
local xtypeof = require("@src/Utility/xtypeof")

local function nearestPair(table: { number }, number: number): (number, number)
	local smallestSoFar: number?, smallestIndex: number = nil, table[1]
	for i, v in ipairs(table) do
		if not smallestSoFar or (math.abs(number - v) < smallestSoFar) then
			smallestSoFar = math.abs(number - v)
			smallestIndex = i
		end
	end
	return smallestIndex, table[smallestIndex]
end

local function Keyframes<T>(
	scope: Types.Scope<any>,
	currentTime: Types.StateObject<number>,
	keyframes: { [number]: T & Types.Animatable }
): Types.StateObject<T & Types.Animatable>
	if Runtime.isStrict() then
		if not castToState(currentTime) then
			Runtime.throwError("invalidStateObject", nil, xtypeof(currentTime), "Keyframes()")
		end
		if typeof(keyframes) ~= "table" then
			Runtime.throwError("invalidKeyframesType", nil, xtypeof(keyframes))
		end
	end
	local timeframes: { number } = {}
	for time in pairs(keyframes) do
		table.insert(timeframes, time)
	end
	table.sort(timeframes)
	local startpoint, endpoint = timeframes[1], timeframes[#timeframes]

	return Fusion.Computed(scope, function(use): any
		local currentTime = use(currentTime)
		if typeof(currentTime) ~= "number" then
			Runtime.throwErrorNonFatal("invalidCurrentTime", nil, xtypeof(keyframes))
			currentTime = startpoint
		end
		currentTime = math.clamp(currentTime, startpoint, endpoint)

		if currentTime <= startpoint then
			return keyframes[startpoint]
		elseif currentTime >= endpoint then
			return keyframes[endpoint]
		end
		for index, time in pairs(timeframes) do
			if currentTime <= time then
				local next = timeframes[index + 1]
				local alpha = time / next
				return lerpType(keyframes[time], keyframes[next], alpha)
			end
		end
		return keyframes[endpoint]
	end)
end

return Keyframes
