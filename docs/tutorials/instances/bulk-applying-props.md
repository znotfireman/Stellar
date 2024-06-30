# Bulk Properties

To help making components easier, Stellar provides the `[Apply]` special key for
bulk applying properties. Given a table of property tables, it applies
properties accounting for default values.

```lua
local Apply = Stellar.Apply

scope:New "TextButton" {
	Name = props.Name,
	[Apply] = {
		{
			[Default "Text"] = "Button",
			[Default "BackgroundColor3"] = Color3.new(0, 1, 0),
		},
		props.Layout
	}
}
```

# Usage

`[Apply]` doesn't need a scope - import it directly from Stellar.

```lua
local Apply = Stellar.Apply
```

