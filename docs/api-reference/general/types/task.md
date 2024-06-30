<div class="stellardoc-api-tags">
<span>since v0.1</span>
<span>type</span>
</div>

<h1 class="stellardoc-api-header" markdown>
<span class="stellardoc-api-icon" markdown>:octicons-note-24:</span>
<span class="stellardoc-api-name">Task</span>
</h1>

Types which [`extendedCleanup`](../members/extendedCleanup.md) has defined
behaviour for. Compared to it's Fusion counterpart, this type has further
coverage, notably including disconnect methods, threads, promise-likes, and
signal-likes.

```lua
type Task =
   Instance
   | RBXScriptConnection
   | thread
   | Scope<any>
   | (...any) -> ...any
   | { [unknown]: Task }
   | { destroy: (self: any) -> () }
   | { Destroy: (self: any) -> () }
   | { disconnect: (self: any) -> () }
   | { Disconnect: (self: any) -> () }
   | { Connected: boolean, Disconnect: (self: any) -> () }
   | { getStatus: (self: any) -> string, cancel: (self: any) -> () }
```
