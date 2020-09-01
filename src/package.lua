-- Written by Rabia Alhaffar in 31/August/2020
-- Package module
-- NOTES: Paths implemented from any Lua so _C.package.cpath for example won't unload libraries if loaded previously!
_C.package = {}
_C.package.loaddir = "lualibs"

-- Rewrite for better control!
if (_C.ffi.os == "Windows") then
  _C.package.config = "\\\n;\n?\n!\n-"
else
  _C.package.config = "///n;/n?/n!/n-"
end

_C.package.path = package.path
_C.package.cpath = package.cpath
_C.package.loaded = package.loaded
_C.package.loadlib = package.loadlib
_C.package.searchers = package.searchers
_C.package.searchpath = package.searchpath

_C.require = function(p)
  if _C.package.loaded[p] then
    return _C.package.loaded[p]
  else
    return _C.package.searchpath(p, "./?/?.lua;./?.lua;./?.lc;./".._C.package.loaddir.."/?/init.lua"..";./".._C.package.loaddir.."/?.lua")
  end
end