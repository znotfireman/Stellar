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
<span class="stellardoc-api-name">Freeze</span>
</h1>

Constructs and returns a state object that outputs the latest unfrozen value
of a target state object, dictated by another state object if the state object 
is frozen.

```lua
function Freeze<T>(
	scope: Scope<any>
	target: StateObject<T>,
	isFrozen: StateObject<boolean>
): StateObject<T>
```

!!! success "Use scopable import syntax"

	This function is intended to be imported as `Stellar.scopable` and accessed
	on a scope:

	```lua
	local scope = Fusion:scoped(Stellar.scopable)
	local frozen = scope:Freeze(targetValue, isFrozen)
	```

---

## Parameters

### scope: `Scope<S>`

The scope which should be used to store destruction tasks for this object.

### target: `StateObject<T>`

The target to observe for values.

### isFrozen: `StateObject<boolean>`

Toggles if the output value is frozen.

---

## Returns

### `StateObject<T>`

A freshly constructed freezable state object.

---

## Usage

```lua
local isFrozen = scope:Value(false)
local value = scope:Value("Foo")

local frozen = scope:Freeze(value, isFrozen)
assert(frozen == "Foo")

isFrozen:set(true)
value:set("Bar")
assert(frozen ~= "Bar")

isFrozen:set(false)
assert(frozen == "Bar")
```

---

## Learn More

- [Freezing States](../../../tutorials/state-objects/freezing-states.md) tutorial