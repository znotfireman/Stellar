--[[
    Provides transformation functions for converting linear RGB values
    into sRGB values.

	Vendored from Fusion 0.3 push-pull-execution.

    RGB color channel transformations are outlined here:
    https://bottosson.github.io/posts/colorwrong/#what-can-we-do%3F
]]

local sRGB = {}

local function transform(channel: number): number
	if channel >= 0.04045 then
		return ((channel + 0.055) / (1 + 0.055)) ^ 2.4
	else
		return channel / 12.92
	end
end

local function inverse(channel: number): number
	if channel >= 0.0031308 then
		return 1.055 * channel ^ (1.0 / 2.4) - 0.055
	else
		return 12.92 * channel
	end
end

function sRGB.fromLinear(rgb: Color3): Color3
	return Color3.new(transform(rgb.R), transform(rgb.G), transform(rgb.B))
end

function sRGB.toLinear(srgb: Color3): Color3
	return Color3.new(inverse(srgb.R), inverse(srgb.G), inverse(srgb.B))
end

table.freeze(sRGB)
return sRGB
