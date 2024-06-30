<div class="stellardoc-api-breadcrumbs">
<a href="../../../">Stellar</a>
<a href="../../">State Objects</a>
<a href="../">Members</a>
</div>

<div class="stellardoc-api-tags">
<span>since v0.1</span>
<span>function</span>
</div>

<h1 class="stellardoc-api-header" markdown>
<span class="stellardoc-api-icon" markdown>:octicons-code-24:</span>
<span class="stellardoc-api-name">flatten</span>
</h1>

Attempts to flatten a state object to it's inner constant value. Can be passed
a `Use` callback and it will use that.

```lua
function flatten<T>(
	target: UsedAs<(...UsedAs<T>)>,
	use: Use?
): T
```

!!! note "Pseudo type"

	Luau doesn't have adequate syntax to represent this function.

---

## Parameters

### target: `UsedAs<(...UsedAs<T>)>,`

The target object to flatten.

### use: `Use?`

The `use()` callback to use, if provided. Fallbacks to Fusion's `peek()`.

---

## Returns

### `T`

The flattened constant value.

---

## Usage

```lua
local value = scope:Value(scope:Value(scope:Value(scope:Value("Foo"))))
local flattened = Stellar.flatten(value)
assert(flattened == "Foo")
```

---

## Learn More

- [Flatten](../../../tutorials/state-objects/flatten.md) tutorial