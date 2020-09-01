-- Written by Rabia Alhaffar in 24/August/2020
-- CLua, Reimplementation of Lua in LuaJIT with C functions using FFI!
ffi = require("ffi")

_C = {}
_C._VERSION = "CLua v0.1"
_C._CODENAME = "(RACCOON)"
_C._AUTHOR = "Rabia Alhaffar"
_C._URL = "https://github.com/Rabios/CLua"
_C._COPYRIGHT_DATE = "2020-2021"

_C.ternary = function(c, v1, v2)
  if c then return v1 else return v2 end
end

-- Load all!
-- NOTES: I don't assume that it's a full implementation of Lua
dofile("ctypes.lua")
dofile("runtime.lua")

local lib = {
  "math.lua", "os.lua", "io.lua", "table.lua", "string.lua", "coroutine.lua", "bit.lua", "ffi.lua", "repl.lua", "package.lua", "debug.lua", "utf8.lua"
}

for l in _C.ipairs(lib, l) do
  _C.dofile(lib[l])
  lib[l] = nil
end

-- Print info
_C.print("%s", _C.cstring(_C._VERSION.." ".._C._CODENAME..", Copyright".." (c) ".._C._COPYRIGHT_DATE.." by ".._C._AUTHOR..", ".._C._URL.."\n"))

-- Available ones: -v -i -e -r -h
local arg = { ... }
local forward = 1

-- Check arguments and do stuff!
for o in _C.ipairs(arg, o) do
  if (arg[o] == "-v") then
    _C.print("%s", "\n".._C._VERSION.."\n")
  elseif (arg[o] == "-i") then
    _C.repl.enabled = true
  elseif (arg[o] == "-r") then
    _C.dofile(arg[o + 1])
  elseif (arg[o] == "-e") then
    _C.loadstring(arg[o + 1])()
  elseif (arg[o] == "-h") then
    _C.os.execute("start https://github.com/Rabios/CLua")
  end
end

-- Enable REPL if enabled from repl.lua
if _C.repl.enabled then _C.repl.run() end

return _C
