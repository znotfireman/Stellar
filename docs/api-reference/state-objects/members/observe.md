<div class="stellardoc-api-breadcrumbs">
<a href="../../../">Stellar</a>
<a href="../../">State Objects</a>
<a href="../">Members</a>
</div>

<div class="stellardoc-api-tags">
<span>since v0.1</span>
<span>state object</span>
</div>

<h1 class="stellardoc-api-header" markdown>
<span class="stellardoc-api-icon" markdown>:octicons-package-24:</span>
<span class="stellardoc-api-name">Observe</span>
</h1>

Connects a callback to updates on given state objects. Returns a function to
unbind observers.

```lua
function Observe(
	scope: Scope<any>
	watching: StateObject<any> | {StateObject<any>},
	callback: () -> ()
): () -> ()
```

!!! success "Use scopable import syntax"

	This function is intended to be imported as `Stellar.scopable` and accessed
	on a scope:

	```lua
	local scope = Fusion:scoped(Stellar.scopable)
	local unbind = scope:ObserveBind(watching, callback)
	```

---

## Parameters

### scope: `Scope<any>`

The scope which should be used to store destruction tasks for this object.

### watching: `StateObject<any> | {StateObject<any>}`

The state object to listen for changes. If provided a table of state objects,
changes are listened for every state object, though the callback only runs once.

### callback: `() -> ()`

The function to call when a change is observed

---

## Returns

### `() -> ()`

A function which when called will unbind the callback.

!!! warning "Observer memory leak"

	Make sure to disconnect any callback functions you create using `Observe()`
	once you're done using them. Disconnecting prevents memory leaks by
	releasing unused observers and state objects.

---

## Usage

```lua
local value = scope:Value("Foo")

local changeCounter = 0
local unbind = scope:ObserveBind(value, function()
	changeCounter += 1
	print(`value is '{peek(value)}', with {tostring(changeCounter)} change(s)`)
end)

--> value is 'Foo', with 1 change(s)

value:set("Bar") --> value is 'Bar', with 2 change(s)
assert(changeCounter == 2)

unbind()
value:set("Grab")
assert(changeCounter ~= 2)
```

---

## Learn More

- [Observing States](../../../tutorials/state-objects/observing-states.md) tutorial