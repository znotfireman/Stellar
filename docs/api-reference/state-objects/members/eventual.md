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
<span class="stellardoc-api-name">Eventual</span>
</h1>

Constructs and returns a new state object that calculates from an asynchronous
computation using values returned from other state objects. Fallbacks to an
default value while the computation is running.

```lua
function Eventual<T, S>(
	scope: Scope<S>
	defaultValue: T,
    computation: (Become, Use, Scope<S>) -> T
): StateObject<T>
```

!!! success "Use scopable import syntax"

	This function is intended to be imported as `Stellar.scopable` and accessed
	on a scope:

	```lua
	local scope = Fusion:scoped(Stellar.scopable)
	local eventual = scope:Computed(defaultValue, computation)
	```

---

## Parameters

### scope: `Scope<S>`

The scope which should be used to store destruction tasks for this object.

### defaultValue: `T`

The default value when a computation is running.

### computation: `(Become, Use, Scope<S>) -> T`

Computes the value that will be used by the eventual. The processor is given a
become function to set its current value, a use function for including other
objects in the computation, and a scope for queueing destruction tasks to run on
re-computation. The given scope has the same methods as the scope used to create
the eventual.

---

## Returns

### `StateObject<T>`

A freshly constructed eventual state object.

---

## Usage

```lua
local Players = game:GetService("Players")

local LOADING_PFP = "rbxassetid://0987654321"
local PLACEHOLDER_PFP = "rbxassetid://1234567890"

local pfp = scope:Eventual(PLACEHOLDER_PFP, function(become, use, scope)
	become(LOADING_PFP)
	return Players:GetUserThumbnailAsync(
		1275426298,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size420x420
	)
end)
```

---

## Learn More

- [Eventuals](../../../tutorials/state-objects/eventuals.md) tutorial