# Flatten

Often when storing state objects inside state objects, you may need to "flatten"
a state object to retrieve an inner value:

```lua title="Fusion"
local value = scope:Value(scope:Value(scope:Value("Hello world!")))
local unwrapped = scope:Computed(function(use)
	return use(use(use(value)))
end)
assert(peek(unwrapped) == "Hello world!")
```

For convenience, Stellar provides the `flatten` function that "flattens" a
state object with any number of depth:

```lua title="Stellar"
local flatten = Stellar.flatten
local value = scope:Value(scope:Value(scope:Value("Hello world!")))
local unwrapped = scope:Computed(function(use)
	return flatten(value, use) :: string
end)
assert(peek(unwrapped) == "Hello world!")
```

This can be useful if you're working with state objects with an unknown number
of depth:


```lua
value:set(scope:Value("Hello world, again!"))
assert(peek(unwrapped) == "Hello world, again!")
```

## Usage
`flatten` does not use a scope, import it to your code directly from Stellar:

```lua
local flatten = Stellar.flatten
```

It takes a state object of any depth, and flattens it until it reaches a
constant value:

```lua
local value = scope:Value(scope:Value(scope:Value("Hello world!")))
print(flatten(value)) --> Hello world!
```

!!! warning "State objects returns a free type"

	Because of limitations with Luau's type engine, `flatten` will always return
	a type of `any`. For now, cast the flattened value to the intended type
	instead:

	```lua
	local value = scope:Value(scope:Value(scope:Value("Hello world!")))
	local flattened = flatten(value) :: string
	assert(typeof(flattened) == "string")
	```

If given a constant value, `flatten` will pass it through:

```lua
print(flatten("This is NOT a state object")) --> This is NOT a state object
```

## Using In Computations

By default, `flatten` only flattens the value once. If you try to `flatten` at
state objects inside a computation, your code breaks quickly:

```lua
local number = scope:Value(scope:Value(scope:Value(2)))
local double = scope:Computed(function(use, scope)
	return flatten(value) * 2
end)

assert(flatten(number) * 2 == peek(double))

-- Uh oh! The calculation won't rerun!
number:set(scope:Value(scope:Value(scope:Value(8))))
assert(flatten(number) * 2 == peek(double)) --> Assertion failed!
```

For convenience, `flatten` accepts a second parameter being a `use` callback.
If provided, `flatten` will use that instead of Fusion's `peek`, thus
registering dependencies, and thus your computation will update.

The above code can be fixed as so:

```lua
local number = scope:Value(scope:Value(scope:Value(2)))
local double = scope:Computed(function(use, scope)
	-- Note the new `use` parameter!
	return flatten(value, use) * 2
end)

assert(flatten(number) * 2 == peek(double))

number:set(scope:Value(scope:Value(scope:Value(8))))
assert(flatten(number) * 2 == peek(double)) --> All good!
```
