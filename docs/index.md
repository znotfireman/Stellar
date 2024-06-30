---
hide:
  - toc
  - navigation
---

<section class="stellardoc-home" markdown>

<div class="stellardoc-home-hero" markdown>

<div class="stellardoc-home-hero-inner" markdown>

<div class="stellardoc-home-hero-description" markdown>

# The radiant set of utilities for [Fusion](https://elttob.uk/Fusion/0.3/).

Stellar is a collection of utilities that extends the Fusion reactive state
library, implementing common conventions that builds upon Fusion's strengths,
making it a breeze to write declarative user interface.

<a href="./tutorials" markdown>
It's dead easy to get started.
<span class="stellardoc-link-chevron">:octicons-chevron-right-24:</span>
</a>

</div>

<div class="stellardoc-home-hero-example" markdown>

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

</div>

</div>

</div>

</section>
