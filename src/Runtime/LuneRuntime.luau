local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
-- Lune
local datetime = require("@lune/datetime")
local stdio = require("@lune/stdio")
local task = require("@lune/task")

local STDIO_ERROR = stdio.color("red") .. stdio.style("bold")
local STDIO_WARN = stdio.color("yellow") .. stdio.style("bold")
local STDIO_RESET = stdio.color("reset") .. stdio.style("reset")

local LuneRuntime = {} :: Types.RuntimeProvider
LuneRuntime.policies = {
   allowWebLinks = true,
}

local schedulerThread: thread? = nil
function LuneRuntime.startScheduler()
   if schedulerThread then
      return
   end
   schedulerThread = task.spawn(function()
      debug.setmemorycategory("STELLAR_SCHEDULER_THREAD")
      while task.wait() do
         Runtime.performUpdateStep(datetime.now().unixTimestamp)
      end
   end)
end

function LuneRuntime.stopScheduler()
   if not schedulerThread then
      return
   end
   task.cancel(schedulerThread)
end

function LuneRuntime.cancelTask(job: thread)
   task.cancel(job)
end

function LuneRuntime.deferTask<A...>(job: (A...) -> () | thread, ...: A...): thread
   if typeof(job) == "function" then
      return task.defer(job, ...)
   end
   return task.defer(coroutine.resume, job, ...)
end

function LuneRuntime.spawnTask<A...>(job: (A...) -> () | thread, ...: A...): thread
   if typeof(job) == "function" then
      return task.spawn(job, ...)
   end
   return task.spawn(coroutine.resume, job, ...)
end

function LuneRuntime.throwErrorNonFatal(messageString: string)
   stdio.ewrite(STDIO_ERROR .. messageString .. STDIO_RESET)
end

function LuneRuntime.throwWarning(messageString: string)
   stdio.write(STDIO_WARN .. messageString .. STDIO_RESET)
end

table.freeze(LuneRuntime)
return LuneRuntime
