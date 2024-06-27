--[[
   Roblox implementation for Stellar's abstract provider layer.
]]

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Runtime = require("@src/Runtime")
local Types = require("@src/Types")

local RobloxRuntime = {} :: Types.RuntimeProvider
RobloxRuntime.policies = {
	allowWebLinks = RunService:IsStudio(),
}

local stopSchedulerFn: () -> ()? = nil
function RobloxRuntime.startScheduler()
	if stopSchedulerFn then
		return
	end
	if RunService:IsServer() then
		local connection = RunService.Heartbeat:Connect(function()
			Runtime.performUpdateStep(os.clock())
		end)
		function stopSchedulerFn()
			connection:Disconnect()
		end
		return
	end
	local name = "STELLAR_UPDATE_STEP_" .. HttpService:GenerateGUID(false):gsub("-", ""):upper()
	RunService:BindToRenderStep(name, Enum.RenderPriority.First.Value + 1, function()
		Runtime.performUpdateStep(os.clock())
	end)
	function stopSchedulerFn()
		RunService:UnbindFromRenderStep(name)
	end
end

function RobloxRuntime.stopScheduler()
	if not stopSchedulerFn then
		return
	end
	stopSchedulerFn()
	stopSchedulerFn = nil
end

function RobloxRuntime.cancelTask(job: thread)
	task.cancel(job)
end

function RobloxRuntime.deferTask<A...>(job: (A...) -> () | thread, ...: A...): thread
	if typeof(job) == "function" then
		return task.defer(job, ...)
	end
	return task.defer(coroutine.resume, job, ...)
end

function RobloxRuntime.delayTask<A...>(delay: number, job: (A...) -> () | thread, ...: A...): thread
	if typeof(job) == "function" then
		return task.delay(delay, job, ...)
	end
	return task.delay(delay, coroutine.resume, job, ...)
end

function RobloxRuntime.spawnTask<A...>(job: (A...) -> () | thread, ...: A...): thread
	if typeof(job) == "function" then
		return task.spawn(job, ...)
	end
	return task.spawn(coroutine.resume, job, ...)
end

function RobloxRuntime.throwErrorNonFatal(messageString: string)
	error(messageString, 0)
end

function RobloxRuntime.throwWarning(messageString: string)
	warn(messageString)
end

table.freeze(RobloxRuntime)
return RobloxRuntime
