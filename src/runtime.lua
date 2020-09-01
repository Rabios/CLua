-- Written by Rabia Alhaffar in 24/August/2020
-- Rewrite of Lua functions like print() and other stuff
ffi.cdef([[
  int printf (const char*, ...);
  void perror (const char *s);
  extern int *_errno(void);
  int atoi(const char *_Str);
  int atof(const char *_Str);
  int _set_error_mode(int _Mode);
]])

_C.print = ffi.C.printf
_C.tonumber = ffi.C.atoi

_C.super_next = function(t, k)
  return k + 1, t[k + 1]
end

-- http://lua-users.org/wiki/GeneralizedPairsAndIpairs
_C.next = function(t, k)
  local m = getmetatable(t)
  local n = m and m.__next or next
  return n(t, k)
end

_C.tostring = function(n)
  if (n <= 0 or n >= 0) then
    return "\""..(n).."\""
  end
end

_C.error = function(msg, code)
  if msg == "" then msg = "Error "..code end
  ffi.C.errno(code)
  ffi.C.perror(msg)
end

-- Custom one by mine :)
_C.super_ipairs = function(...)
  p = { ... }
  i = p[1]
  arr = p[2]
  f = p[3]
  flush = p[4]
  for tv = 1, #arr, 1 do
    if type(f) == "function" then
      i = i + 1
      f(i)
    end
  end
  -- You can flush and destory array/table after loop if you don't want to use it later ;)
  if flush and flush == true and not (#arr == 0) then
    arr = nil
  end
  p = nil
end

_C.iterate = function(t, i)
  i = i + 1
  local v = t[i]
  if v then
    return i, v
  end
end

-- The same Lua ipairs and pairs
_C.ipairs = function(t)
  return _C.iterate, t, 0
end

_C.pairs = function(t)
  return next, t, nil
end

-- Implemented one myself so no need to waste time :)
_C.assert = function(v, msg)
  if not v then
    _C.print("\n%s", "error: "..msg)
    return false, "error: "..msg
  else
    return true
  end
end

-- Unfortunately, empty table returns "string" (This is the only problem)
-- But i assume this should works 100%
_C.super_type = function(v, t)
  if (t == "number") then
    return (v <= 0 or v >= 0)
  elseif (t == "boolean") then
    return (v == true or v == false)
  elseif (t == "function") then
    return _C.assert(v(), "Should works!")
  elseif (t == "string") then
    return (v[#v] == nil)
  elseif (t == "table") then
    return (not v[#v] == nil)
  elseif (t == "thread") then
    return (not v.thread == nil)
  elseif (t == "nil") then
    return (t == nil) or not (v)
  else
    return nil
  end
end

-- require function was lying here :(
-- But moved to package.lua

_C.loadstring = function(str)
  if _C.assert(load(str), "Loading code string failed!") then
    return load(str)
  end
end

_C.loadfile = function(path)
  local f = io.open(path)
  local str = f:read("*a")
  io.close(f)
  return load(str)
end

_C.dofile = function(path)
  if _C.assert(_C.loadfile(path), "Loading file "..path.." failed!\n") then
    return _C.loadfile(path)()
  end
end

_C.rawlen = function(o)
  if o and (type(o) == "table") then return #o end
end

_C.rawget = function(t, i)
  if t and (type(t) == "table") then
    return t[i]
  end
end

_C.rawset = function(t, i, v)
  if t and (type(t) == "table") then
    t[i] = v
  end
end

-- rawequal compares by tables length currently
_C.rawequal = function(a, b)
  if a and b and (type(a) == "table") and (type(b) == "table") then
    return #a == #b
  end
end

_C.pcall = function(f, ...)
  _C.assert(f(...), "Calling function ".._C.tostring(f).." failed!\n")
end

_C.xpcall = function(f, msgh, ...)
  _C.assert(f(...), msgh)
end

_C.setenv = function(t)
  _ENV = t
end

-- Wrap internals!
_C.getmetatable = getmetatable
_C.setmetatable = setmetatable