--[[
	Formats a Stellar-specific error message. Partically vendored from Fusion
	0.3 push-pull-execution.
]]

local Types = require("@src/Types")
local messages = require("@src/Logging/messages")

local ERROR_API_URL = "znotfireman.github.io/stellar/api-reference/errors#"
local ERROR_PLACEHOLDER = "ERROR_MESSAGE"

local function formatError(
	runtime: Types.RuntimeProvider?,
	messageId: string,
	errorOrTrace: Types.Error | string | nil,
	...: any
): string
	local originalMessageId = messageId
	local message: string = messages[messageId]
	if not message then
		messageId = "unknownMessage"
		message = messages.unknownMessage
	end
	if select("#", ...) > 0 then
		message = message:format(...)
	end
	local error: Types.Error? = if typeof(errorOrTrace) == "table" then errorOrTrace else nil
	local trace: string? = if typeof(errorOrTrace) == "table" then errorOrTrace.trace else errorOrTrace
	message = message:gsub(ERROR_PLACEHOLDER, error and error.message or originalMessageId)
	local message = "[Stellar] " .. message .. "\nID: " .. messageId
	if runtime and runtime.policies.enableWebLinks then
		message ..= "\nLearn more: " .. ERROR_API_URL .. messageId:lower()
	end
	if trace ~= nil then
		message ..= ` \nStack trace:\n{trace}`
	end
	return message:gsub("\n", "\n    ")
end

return formatError
