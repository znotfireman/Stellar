local function deepfreeze<T>(target: {} & T): T
   table.freeze(target)
   for _, v in pairs(target) do
      if typeof(v) == "table" then
         deepfreeze(v)
      end
   end
   return target
end

return deepfreeze
