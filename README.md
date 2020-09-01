# CLua (Codenamed "RACCOON")

> NOTES: Project only for LuaJIT, If you don't use LuaJIT install luaffi from LuaRocks to use this! :(

<div align="center"><img src="https://github.com/Rabios/CLua/blob/master/clua_logo.png"></div>
<br>

Most of Lua functions implementation via C code using LuaJIT's FFI and pure Lua code.

So...You can say that CLua is actually a code booster LOL, And modified version Lua in same time :)

### Why?

- Fallback intended for who can't use some functions in Lua or LuaJIT!
- Offers techniques for who interested in rewriting functions!
- Portable and fits anywhere LuaJIT or Lua + luaffi can runs!
- Offers deprecated stuff!

### Usage

The [CLua primer](https://github.com/Rabios/CLua/blob/master/examples/primer.lua) can explain some stuff!

NOTE: See [documentation](https://github.com/Rabios/CLua/blob/master/documentation.md) and the [API](https://github.com/Rabios/CLua/blob/master/api.md) for more info!

### Command line arguments

CLua also introduces simple REPL and command line with following arguments!

```
-r file -> Runs a file (If you required CLua comment his requiring line)
-e code -> Executes a code
-i      -> Runs REPL
-v      -> Prints version
-h      -> Help (Opens repository page)
```

> NOTE: You can use multiple arguments!

### Changes from Lua

- No metatable based functions as in `string` and `io` modules, The first parameter of each function of them is the file or string itself, Then continue with function parameters!

- ipairs now needs to have 2 parameters by the way to get index of table!

```lua
local arr = { 1, 2, 3, 4, 5 }
for i in _C.ipairs(arr, i) do
  _C.print("%d", arr[i])
end
```

### NOTES

1. To keep and not overwrite default Lua VM, CLua uses `_C` instead of `_G`.
2. CLua is somehow ready for production but i can't recomment it cause it does not reflect the original Lua API, It's intended to fix problems as CLua introduces fallbacks for them :)
3. Some functions are internal so they still use original Lua ones. (And not rewritten!)
4. If you get 0 as values for variables created via FFI, See [`ctypes.lua`](https://github.com/Rabios/CLua/blob/master/src/ctypes.lua) types functions, With using `_C.tonumber` and `_C.tostring` when needed!

### Special Thanks

- Roberto Ierusalimschy, For ["Programming in Lua" book](https://www.lua.org/pil/contents.html).
- [Diego Martínez](https://github.com/kaeza) for [bitty](https://gist.github.com/kaeza/8ee7e921c98951b4686d) (I used bnot from bitty).
- [Astie Teddy](https://github.com/TSnake41) for tracing logs implementation (Originated from raylib-lua).

### License

See `LICENSE.txt` for bindings license and `LICENSES.txt` for third party licenses.
