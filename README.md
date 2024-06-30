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

[![Build status](https://github.com/znotfireman/Stellar/workflows/CI/badge.svg)](https://github.com/znotfireman/Stellar/actions)

# The radiant set of utilities for [Fusion](https://elttob.uk/Fusion/0.3/).

Stellar is a collection of utilities that extends the Fusion reactive state
library, implementing common conventions that builds upon Fusion's strengths,
making it a breeze to write declarative user interface.

It's dead easy to get started:

```lua
local Fusion = require(ReplicatedStorage.Fusion)
local Stellar = require(ReplicatedStorage.Stellar)

local Children = Stellar.Children
local extendedCleanup = Stellar.extendedCleanup

local scope = Fusion:scoped(Stellar.scopable)

local message = scope:Value("Hello, Stellar!")
scope:Derive(ReplicatedStorage.TemplateButton) {
    Text = message,
    [Children] = WithChild "UIStroke" {
        Color = Color3.new(1, 0, 0)
    }
}
scope:ObserveBind(message, print)
extendedCleanup(scope)
```

## Installation
