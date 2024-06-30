<div class="stellardoc-api-breadcrumbs">
<a href="../../../">Stellar</a>
<a href="../../">General</a>
<a href="../">Members</a>
</div>

<div class="stellardoc-api-tags">
<span>since v0.1</span>
<span>function</span>
</div>

<h1 class="stellardoc-api-header" markdown>
<span class="stellardoc-api-icon" markdown>:octicons-code-24:</span>
<span class="stellardoc-api-name">extendedCleanup</span>
</h1>

Attempts to destroy a variadic amount of arguments based on its runtime type.
Compared with its Fusion's `doCleanup` counterpart, `extendedCleanup` has
extended coverage.

```lua
function extendedCleanup(
	...: Task
): ()
```

!!! warning "This is the point of no return!"

	Treat everything passed to extendedCleanup as completely gone. Ensure all
	references to those values are removed, and ensure your code never uses them
	again.

---

## Parameters

### [`...: Task`](../types/task.md)

A variadic of arguments which should be disposed of; each value's runtime type
will be inspected to determine what should happen.

- if `function`, it is called;
- if `thread`, it is cancelled;
- if its a promise, it is cancelled;
- if `:destroy()`, `:destroy()` is called;
- if `:Destroy()`, `:Destroy()` is called;
- if `:disconnect()`, `:disconnect()` is called;
- if `:Disconnect()`, `:Disconnect()` is called;
- if Instance, `:Destroy()` is called;
- if RBXScriptConnection or a signal-like object, `:Disconnect()` is called;
- if a scope, `extendedCleanup` is called on all members;
- else, the value is ignored.

---

## Usage

```lua
Stellar.extendedCleanup(
	PlayerGui.TextLabel,
	task.delay(5, function()
		print("I will NOT be run")
	end),
	Promise.new(function(resolve, reject, onCancel)
		onCancel(function()
			print("Promise is cancelled")
		end)
		task.wait(5)
		resolve()
	end)
)
```

---

## Learn More