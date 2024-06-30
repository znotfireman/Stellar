# Deriving Instances
To help make templating more ergonomic, Stellar provides a `Derive` function for
cloning an instance, then hydrating it using a table of properties. If you pass
in state objects, changes will be applied immediately:
```lua
local isEnabled = scope:Value(true)
scope:Derive(ReplicatedStorage.SubscribeBtn) {
	Text = scope:Computed(function(use, scope)
		return use(isEnabled) and "Subscribe" or "Disabled"
	end)
}
```
## Usage
The `Derive` function is called in two parts. First, call the function with the
template instance you want to clone from, then pass in the property table:

```lua
scope:Derive(StarterPack.Sword)({
	Name = "Illumina",
	Tooltip = "It is light, agile, and deadly."
})
```

For brevity, if you're using curly braces `{}` to pass your properties in, it is
recommended to omit the extra parentheses.

```lua
scope:Derive(StarterPack.Sword) {
	Name = "Illumina",
	Tooltip = "It is light, agile, and deadly."
}
```

`Derive` returns the instance you give it, so you can use it in declarations:

```lua
local illumina = scope:Derive(StarterPack.Sword) {
	Name = "Illumina",
	Tooltip = "It is light, agile, and deadly."
}
```

Constant values are applied directly, while state objects have changes observed
and binded:

```lua
local message = scope:Value("Loading...")

scope:Derive(PlayerGui.LoadingMsg) {
	Text = message
}

print(PlayerGui.Message.Text) -- Loading...
message:set("Finished!")

task.defer(function() -- changes are done in the next resumption
	print(PlayerGui.Message.Text) -- All done!
end)
```

In short, `Derive` is a short-form for cloning an instance, and applying 
`Hydrate` on it:

```lua
scope:Derive(workspace.Baseplate) { ... }
-- is basically the same as
scope:Hydrate(workspace.Baseplate:Clone()) { ... }
```
## The Problem
In Fusion version 0.3, the `Hydrate` function is your sole approach for 
modifying existing instances. While it allows property updates, as seen in the 
example below:

```lua
-- Fusion 0.3
scope:Hydrate(workspace.BasePlate) {
	Color = Color3.new(0, 1, 1),
	Reflection = 1,
}
```

...its usage is discouraged by maintainers, with plans to replace it with more 
robust primitives in the near future noted by [this Fusion Github issue.](https://github.com/dphfox/Fusion/issues/206) 

Previously, `Hydrate` served two primary purposes:

1. Cloning functionality from a static template and integrating it with the new instance.
2. Hooking reactive objects to existing instances to extract properties and child elements.

To fulfill these use cases, Stellar exports improved methods for both use cases, 
eliminating the need for `Hydrate`.

With the former, `Derive` allows you to derive from templates as a clone, though
Stellar offers primitives to hydrate child instances too. With the latter,
Stellar offers a diverse set of selectors that can extract or bind values from
instance, providing a more ergonomic approach compared to `Hydrate`.

In the following tutorials, you will delve deeper into Stellar's child hydration and selector
functionalities.