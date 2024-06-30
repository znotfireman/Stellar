# Using Stellar

## Connecting To Fusion

Stellar needs a valid Fusion 0.3 installation to function. For convenience, 
Stellar can locate your Fusion installation automatically if it matches all
of the following:

- Fusion and Stellar are siblings in the data model AND
- If Stellar is compiled for Roblox, that Fusion is a `ModuleScript` instance OR
- If Stellar is compiled for general usage, that Fusion is in a `vendor`,
  `Vendor`, `packages`, or a `Packages` folder.

If you need to connect to Fusion directly, Stellar exports the `setInstallation`
method. Given a valid Fusion installation, Stellar returns a result which if
valid, can be extracted to get the old Fusion installation, if any.

```lua
local myFusionInstall = require(ReplicatedStorage.Fusion)
local result = Stellar.setInstallation(myFusionInstall)
if result.ok then
	print("Successfully set installation, old install:", result.value)
else
	print("Failed to set installation:", result.reason)
end
```

## Importing Stellar

In Fusion, to help manage the destruction of objects, Fusion exports the `scoped`
function to create cleanup tables.

```lua
local Fusion = require(ReplicatedStorage.Fusion)
local scoped = Fusion.scoped
```

For convenience, you can pass a table of constructors into `scoped`. Frequently
you will pass Fusion directly - it's a table with constructors, too.

```lua
local scope = scoped(Fusion)
local value = scope:Value("Foo")
```

This gives you access to all of Fusion's constructors without having to import
each one manually.

Try importing Stellar - it's also a table of constructors.

```lua
local scope = scoped(Fusion, Stellar)
```

However, directly combining `Fusion` with `Stellar` will lead to an error:

``` title="Output"
[Fusion] Multiple definitions for 'Children' found while merging.
	(ID: mergeConflict)
	Learn more: https://elttob.uk/Fusion/0.3/api-reference/general/errors/#mergeconflict
```

This is because Fusion tried to merge together multiple tables, but several
definitions of the same key was found, and it's unclear which one you intended
to have in the final merged result.

Instead, Stellar exposes a `scopable` table, free of conflicts:

```lua
local scope = scoped(Fusion, Stellar.scopable)
```

The above code can be simplified even further:

```lua
local scope = Fusion:scoped(Stellar.scopable)
```

!!! success "This syntax is recommended"

	From now on, you'll see this syntax used throughout the tutorials.

Both Stellar and Fusion's constructors can be used through the scope:

```lua
-- from Fusion
local value = scope:Value("Foo")
local secondValue = scope:Value("Bar")
-- from Stellar
local unbindAll = scope:BindObserve({ value, secondValue }, function()
	local value, secondValue = peek(value), peek(secondValue)
	print(value, secondValue)
end)
```

Stellar's objects can be imported directly into your code:

```lua
local Children = Stellar.Children
scope:New "Frame" {
	[Children] = {
		-- ...
	}
}
```

## Why A Separate Table?

Along with constructors, Stellar exports several improved variants of Fusion's
own objects, notably re-exporting the `[Children]` special key.

Because Fusion tries to prevent many errors by design, so too does Stellar have
to account for Fusion's restrictions. Therefore, when Fusion tries to merge
Stellar into the scope, Fusion throws an error because it found a conflict it
cannot resolve.

To remedy this, Stellar provides a `scopable` table specifically designed to
address this conflict. It re-exports Stellar's constructors without conflicting
keys, which is designed to be used with `scoped` syntax.

It's true that perhaps this will make some code longer. However, the increased
explicitness and attention to detail here far outweighs that negative.