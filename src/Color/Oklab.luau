--[[
	Provides functions for converting Color3s into Oklab space, for more
	perceptually uniform colour blending.

	Vendored from Fusion 0.3 push-pull-execution.

	See: https://bottosson.github.io/posts/oklab/
]]

local sRGB = require("@src/Color/sRGB")

local Oklab = {}

local function cbrt(x: number): number
	return x ^ (1 / 3)
end

function Oklab.fromLinear(rgb: Color3): Vector3
	local red, green, blue = rgb.R, rgb.G, rgb.B

	local l = 0.4122214708 * red + 0.5363325363 * green + 0.0514459929 * blue
	local m = 0.2119034982 * red + 0.6806995451 * green + 0.1073969566 * blue
	local s = 0.0883024619 * red + 0.2817188376 * green + 0.6299787005 * blue

	local lRoot = cbrt(l)
	local mRoot = cbrt(m)
	local sRoot = cbrt(s)

	return Vector3.new(
		0.2104542553 * lRoot + 0.7936177850 * mRoot - 0.0040720468 * sRoot,
		1.9779984951 * lRoot - 2.4285922050 * mRoot + 0.4505937099 * sRoot,
		0.0259040371 * lRoot + 0.7827717662 * mRoot - 0.8086757660 * sRoot
	)
end

function Oklab.fromSRGB(srgb: Color3): Vector3
	return Oklab.fromLinear(sRGB.toLinear(srgb))
end

function Oklab.toLinear(lab: Vector3, unclamped: boolean?): Color3
	local lRoot = lab.X + lab.Y * 0.3963377774 + lab.Z * 0.2158037573
	local mRoot = lab.X - lab.Y * 0.1055613458 - lab.Z * 0.0638541728
	local sRoot = lab.X - lab.Y * 0.0894841775 - lab.Z * 1.2914855480

	local l = lRoot ^ 3
	local m = mRoot ^ 3
	local s = sRoot ^ 3

	local red = l * 4.0767416621 - m * 3.3077115913 + s * 0.2309699292
	local green = l * -1.2684380046 + m * 2.6097574011 - s * 0.3413193965
	local blue = l * -0.0041960863 - m * 0.7034186147 + s * 1.7076147010

	if not unclamped then
		red = math.clamp(red, 0, 1)
		green = math.clamp(green, 0, 1)
		blue = math.clamp(blue, 0, 1)
	end

	return Color3.new(red, green, blue)
end

function Oklab.toSRGB(lab: Vector3, unclamped: boolean?): Color3
	return sRGB.fromLinear(Oklab.toLinear(lab, unclamped))
end

table.freeze(Oklab)
return Oklab
