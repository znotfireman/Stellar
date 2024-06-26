local function detectRuntime(): "lune" | "roblox" | "unsure"
   if _G.UTIL_TARGET == "roblox" or typeof(script) == "Instance" then
      return "roblox"
   elseif string.sub(_VERSION, 1, 5):lower() == "lune " then
      return "lune"
   end
   return "unsure"
end

return detectRuntime
