# Selectors

Often, you will hook reactive objects to existing instances to extract
properties and child elements. Stellar exports selectors which are more
ergonomic.

```lua
local part = scope:ChildNamed(workspace, "Part")
local partColour = scope:PropertyOf(foo, "Color")
local light = scope:ChildOfClass(part, "Light")
local unbind = scope:BindProperty(light, "Color", partColour)

assert(peek(part).Color == peek(light).Color)
task.delay(5, unbind)
```

## Usage

Stellar provides various selectors categorized by which value it targets, either
ancestors, attributes, children, descendants, properties, or tags, and their
functionality:

- `AncestorsOf`, `AttributesOf`, `ChildrenOf`, and `DescendantsOf` extracts
  the corresponding values from an instance.
- `AncestorNamed`, `AttributeNamed`, `ChildNamed`, and `DescendantNamed` 
  extracts the first instance that matches a given name.
- `AncestorWhichIsA`, `ChildWhichIsA`, `DescendantWhichIsA` extracts the
  first instance that inherits from a given class name.
- `AncestorOfClass`, `ChildOfClass`, `DescendantOfClass` extracts the first
  instance that matches a given class name.
- `BindAttribute`, `BindTags`, and `BindProperties` binds a state object to the
  corresponding value.
- Stellar also exports more niche selectors too, such as `PropertyOf`,
  `HasAttribute` and `HasTag`.

Take `AncestorsOf`. Given an instance, it returns a state object that outputs an
ordered array of its ancestry from the ancestor nearest to it, to its data
model:

```lua
local ancestry = scope:AncestorOf(ReplicatedStorage.Gui.Foundational.Button)
scope:ObserveBind(ancestry, print) 
-- prints {[1] = Foundational, [2] = Gui, [3] = ReplicatedStorage, [4] = game}
```

The `xNamed`, `xWhichIsA` and `xOfClass` returns a state object that finds the
first instance that matches the given value. If no such instance exists, the
selectors return nil:

```lua
local image = scope:New "EditableImage" { Parent = PlayerGui }
local selector = scope:ChildOfClass(PlayerGui, "EditableImage")
local unbind = scope:Observe(selector, print)
-- observer prints 'EditableImage'
image:Destroy()
-- observer prints nil
unbind()
```

Finally, the `BindX` selectors binds a state object to a value, and returns
a callback to unbind said state object:

```lua
-- extracts a property from an instance
local color = scope:PropertyOf(GuiColorValue, "Value")
assert(typeof(peek(color)) == "Color3")

-- binds a property to an instance
local unbind = scope:BindProperty(Frame, "BackgroundColor3", color)
assert(Frame.BackgroundColor3 = peek(color))

task.delay(5, unbind)
```

## When You'll Use This

Fusion already provides primitives to extract and bind state objects to
instances. However, it often makes code clunkier, such as this:

```lua title="Fusion"
-- extraction
local textClr = scope:Value(Color3.new())
scope:Hydrate(TextButton) {
	[Out "TextColor3"] = textClr
}

-- binding
local imageClr = scope:Value(Color3.new(1, 0, 1))
scope:Hydrate(ImageLabel) {
	ImageColor3 = imageClr
}
```

To see how selectors improves the readability and conciseness of your code,
consider this next snippet. You can write it with Stellar or with vanilla Fusion
- here's how both looks:

=== "Fusion"

	```lua
	-- Get part
	local part: Value<BasePart?> = scope:Value(nil)
	local function getPart()
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") then
				part:set(v)
				break
			end
		end
	end
	getPart()
	table.insert(scope, {
		workspace.ChildAdded:Connect(getPart),
		workspace.ChildRemoved:Connect(getPart)
	})
	
	-- Get text label
	local textLabel: Value<TextLabel?> = scope:Value(nil)
	scope:Observer(part):onBind(function()
		local part = peek(part)
		if not part then
			return textLabel:set(nil)
		end
		for _, v in ipairs(part:GetChildren()) do
			if v.ClassName == "TextLabel" then
				textLabel:set(v)
				break
			end
		end
	end)
	
	-- Get color of part
	local partColor = scope:Value(Color3.new())
	local connection: RBXScriptConnection? = nil
	scope:Observer(part):onBind(function()
		local part = peek(part)
		if connection or not part then
			connection:Disconnect()
			connection = nil
		end
		if not part then
			return
		end
		connection = part
			:GetPropertyChangedSignal("Color")
			:Connect(function()
				partColor:set(part.Color)
			end)
	end)

	-- Bind color of part to the color of text label
	scope:Observer(partColor):onBind(function()
		local textLabel = peek(textLabel)
		if not textLabel then
			return
		end
		textLabel.TextColor3 = peek(partColor)
	end)
	```

=== "Stellar"

	```lua
	-- Get part
	local part = scope:ChildWhichIsA(workspace, "BasePart")

	-- Get text label
	local textLabel = scope:ChildOfClass(part, "TextLabel")

	-- Get color of part
	local partColor = scope:PropertyOf(part, "Color")
	
	-- Bind color of part to the color of text label
	local unbind = scope:BindProperty(surfaceGui, "TextColor3", partColor)
	```

With Fusion, you have to write a slew of manual `Observer` calls and plenty of
boilerplate. Primitives such as `Hydrate` or `[Out]` are unusable as it doesn't
react with changes, nor does it allow you to unbind once you are done with it.

Stellar is an improvement to Fusion as it does away the boilerplate altogether.
Every selector is designed to handle missing instances automatically, so if an
instance along the chain is missing, changes are caught at the end. Every
selector also works with state objects, so changes cascade down the chain. This
makes much more sense when defining 'flows' of data, where hydration is used
outside of templating.

## Reactive Changes

There is another benefit to using selectors too; since all selectors use state
objects, any missing instances are handled and picked up at the end of a chain.
Since everything uses state objects, changes cascade down a chain, making it
dead easy to write reactive flows of 'data'.

```lua
local probablyDoesntExist = scope:ChildOfClass(workspace, "WedgePart")
print(peek(probablyDoesntExist)) --> nil
scope:New "WedgePart" {
	Parent = workspace
}
print(peek(probablyDoesntExist)) --> WedgePart
```

-