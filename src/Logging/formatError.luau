local function formatMessage(errorObject: any, template: string, ...: any)
   if select("#", ...) > 0 then
      template = template:format(...)
   end
   local message = "[Stellar] " .. template
end
