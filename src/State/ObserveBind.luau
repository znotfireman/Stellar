--[[
   Constructs Observers watching state objects, returns a callback to unbind
   aforementioned Observers. Also runs the callback immediately.
]]

local Fusion = require("@src/Fusion")
local Runtime = require("@src/Runtime")
local Types = require("@src/Types")
local castToState = require("@src/State/castToState")

local function ObserveBind(
	scope: Types.Scope<any>,
	watching: Types.StateObject<any> | { Types.StateObject<any> },
	callback: () -> ()
): () -> ()
	if castToState(watching) then
		return Fusion.Observer(scope, watching):onBind(callback)
	end
	if Runtime.isStrict() and typeof(watching) ~= "table" then
		return Runtime.throwError("invalidStateObject", nil, typeof(watching), "ObserveBind()")
	end
	local disconnectFns: { () -> () } = {}
	for _, stateObject in ipairs(watching) do
		if Runtime.isStrict() and not castToState(stateObject) then
			return Runtime.throwError("invalidStateObject", nil, typeof(watching), "ObserveBind()")
		end
		-- Use onChange as to not bind the callback several times
		table.insert(disconnectFns, Fusion.Observer(scope, watching):onChange(callback))
	end
	Runtime.spawnTask(callback)
	local connected = false
	local function unbind(): ()
		if not connected then
			return Runtime.throwError("unbindedTwice", nil, "bounded observers")
		end
		connected = false
		for _, disconnect in ipairs(disconnectFns) do
			disconnect()
		end
		table.clear(disconnectFns)
	end
	return unbind
end

return ObserveBind
