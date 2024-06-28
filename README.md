<img
	align="right"
	src="./gh-assets/logo-dark.svg#gh-dark-mode-only"
	alt="Stellar"
	width="200">
<img
	align="right"
	src="./gh-assets/logo-light.svg#gh-light-mode-only"
	alt="Stellar"
	width="200">

# Stellar

[![Build status](https://github.com/znotfireman/Stellar/workflows/CI/badge.svg)](https://znotfireman/Stellar/actions)

**A radiant collection of Fusion v0.3 utilities.**

Stellar is a collection of utilities that extend the Fusion reactive state
library, implementing common conventions that builds upon Fusion's strengths,
making it a breeze to write declarative user interface.

It's dead easy to get started:

```lua
local Fusion = require("@pkg/Fusion")
local Stellar = require("@pkg/Stellar")

-- Stellar is designed to be usable with scoped() syntax
local scope = Fusion:scoped(Stellar.scopable)

-- All of Fusion constructors are still exposed
local compliment = scope:Value("very awesome")
local message = scope:Computed(function(use, scope)
   return "betcha stellar is " .. use(compliment)
end)

-- Stellar's own constructors are exposed too!
local Children, Child, WithChild, = Stellar.Children, Stellar.Child, Stellar.WithChild
local label = scope:Derive (ReplicatedStorage.TemplateBtn) {
    Text = message,
    [Children] = Child {
        WithChild "UIStroke" {
            Color = scope:Eventual(Color3.new(1, 0, 0), function(become, use, scope)
                become(Color3.new(1, 0, 0))
                task.wait(5) -- very expensive computation
                return Color3.new(0, 1, 0)
            end)
        }
    }
}
```

## Installation
