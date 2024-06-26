local Types = require("@src/Types")

local Children = {} :: Types.SpecialKey
Children.type = "SpecialKey"
Children.kind = "Stellar.Children"
Children.stage = "descendants"

function Children:apply(scope, value, instance) end

table.freeze(Children)
return Children
