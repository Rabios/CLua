# CLua documentation

Welcome to CLua, Reimplementation of Lua functions from zero using C via FFI and pure Lua code!

### Index

- [Setup](#setup)
- [First Steps](#first-steps)
- [Compatibility](#compatibility)

### Setup

Get `clua.lua` from [here](https://github.com/Rabios/CLua/blob/master/build/clua.lua) and require it, Note that if you don't use LuaJIT but have LuaRocks you need to install luaffi module (rock).

Note that if you did installed luaffi module, require it before requiring CLua.

### First Steps

```lua
-- Remove this comment and require luaffi here in case you don't use LuaJIT! 
local _C = require("clua")
_C.print("%s", "hello world!")
```

Then run it with your preferred Lua :)

> NOTES: If you get 0 as values for variables created via FFI, See [`ctypes.lua`](https://github.com/Rabios/CLua/blob/master/src/ctypes.lua) types functions, With using `_C.tonumber` and `_C.tostring` when needed!

### Compatibility

See the [API](https://github.com/Rabios/CLua/blob/master/api.md) for more info.