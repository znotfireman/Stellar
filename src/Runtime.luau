--[[
	Abstraction layer between Stellar's internals and external environments,
	allowing for flexible integration with schedulers and test mocks.
]]

local Types = require("@src/Types")
local formatError = require("@src/Logging/formatError")

local Runtime = {}

-- Multiplier for running safety checks across the Stellar codebase. Used to
-- stricten tests on infinite loop detection during unit testing.
Runtime.safetyTimeMultiplier = 1

local currentRuntime: Types.RuntimeProvider? = nil
local lastUpdateStep = 0
local updateStepCallbacks: { [{}]: (now: number) -> () } = {}

-- During critical periods of a program, Stellar can decide to change it
-- internal to be more performance friendly. Holding strong references here
-- would let threads that are cancelled before the runtime finishes its callback
-- be held strongly forever.
local timeCriticalThreads: { [thread]: boolean } = setmetatable({}, { __mode = "k" }) :: any

function Runtime.isTimeCritical(): boolean
	return timeCriticalThreads[coroutine.running()] == true
end

function Runtime.runTimeCritical<A..., R...>(callback: (A...) -> R..., ...: A...): R...
	local thread = coroutine.create(callback)
	timeCriticalThreads[thread] = true
	local pack = table.pack(coroutine.resume(thread, ...))
	if coroutine.status(thread) ~= "dead" then
		Runtime.throwError("cannotYield", nil, "a time critical section of code")
		Runtime.cancelTask(thread)
	end
	timeCriticalThreads[thread] = nil
	return table.unpack(pack :: any, 1, pack.n)
end

function Runtime.setProvider(newRuntime: Types.RuntimeProvider): Types.RuntimeProvider?
	local oldRuntime = currentRuntime
	if oldRuntime then
		oldRuntime.stopScheduler()
	end
	currentRuntime = newRuntime
	newRuntime.startScheduler()
	return oldRuntime
end

function Runtime.cancelTask(job: thread): ()
	if not currentRuntime then
		return Runtime.throwError("noRuntimeProvider")
	end
	currentRuntime.cancelTask(job)
end

function Runtime.deferTask<A...>(job: (A...) -> () | thread, ...: A...): thread
	if not currentRuntime then
		return Runtime.throwError("noRuntimeProvider")
	end
	return currentRuntime.deferTask(job, ...)
end

function Runtime.delayTask<A...>(delay: number, job: (A...) -> () | thread, ...: A...): thread
	if not currentRuntime then
		return Runtime.throwError("noRuntimeProvider")
	end
	return currentRuntime.delayTask(delay, job, ...)
end

function Runtime.spawnTask<A...>(job: (A...) -> () | thread, ...: A...): thread
	if not currentRuntime then
		return Runtime.throwError("noRuntimeProvider")
	end
	return currentRuntime.spawnTask(job, ...)
end

function Runtime.throwError(messageId: string, errorObject: Types.Error?, ...: any): never
	local message = formatError(currentRuntime, messageId, errorObject, ...)
	error(message, 0)
end

function Runtime.throwErrorNonFatal(messageId: string, errorObject: Types.Error?, ...: any)
	local message = formatError(currentRuntime, messageId, errorObject, ...)
	if not currentRuntime then
		return print(message)
	end
	currentRuntime.throwErrorNonFatal(message)
end

function Runtime.throwWarning(messageId: string, ...: any)
	local message = formatError(currentRuntime, messageId, nil, ...)
	if not currentRuntime then
		return print(message)
	end
	currentRuntime.throwWarning(message)
end

function Runtime.onUpdateStep(callback: (now: number) -> ()): () -> ()
	local identifier = {}
	updateStepCallbacks[identifier] = callback
	return function()
		updateStepCallbacks[identifier] = nil
	end
end

function Runtime.performUpdateStep(now: number)
	lastUpdateStep = now
	for _, callback in pairs(updateStepCallbacks) do
		xpcall(callback, warn, now)
	end
end

function Runtime.lastUpdateStep(): number
	return lastUpdateStep
end

table.freeze(Runtime)
return Runtime
