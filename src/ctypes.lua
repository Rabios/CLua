-- Written by Rabia Alhaffar in 24/August/2020
-- C types creation part
_C.TRUE = 0
_C.FALSE = -1
_C.NULL = nil
_C.NUL = "\0"

_C.int = function(n)
  return ffi.new("int", n) + 0
end

_C.float = function(n)
  return ffi.new("float", n) + 0.0
end

_C.double = function(n)
  return ffi.new("double", n) + 0.0
end

_C.uint = function(n)
  return ffi.new("unsigned int", n) + 0
end

_C.ufloat = function(n)
  return ffi.new("unsigned float", n) + 0.0
end

_C.uint_long_long = function(n)
  return ffi.new("unsigned long long int", n) + 0
end

_C.char = function(c)
  return ffi.new("char", c)
end

_C.cstring = function(s)
  return ffi.string(s)
end

_C.array = function(ctype, ...)
  local args = { ... }
  if (#args == 1) then
    if (ctype == "char") then
      return ffi.new(ctype.."[?]", args[1])
    else
      return ffi.new(ctype.."["..args[1].."]")
    end
  else
    return ffi.new(ctype.."["..#args.."]", args)
  end
end