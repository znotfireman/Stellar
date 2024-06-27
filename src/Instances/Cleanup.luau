--[[
   A special key allowing users to insert clean up tasks during instance
   construction.

   TODO: [Cleanup] should use `extendedCleanup()`
]]

local Types = require("@src/Types")

local Cleanup = {} :: Types.SpecialKey
Cleanup.type = "SpecialKey"
Cleanup.kind = "Stellar.Cleanup"
Cleanup.stage = "observer"

function Cleanup:apply(scope, value, instance)
   table.insert(scope, value :: any)
end

return Cleanup
