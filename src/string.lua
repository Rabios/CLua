-- Written by Rabia Alhaffar in 24/August/2020
-- Lua strings library
_C.string = {}

-- TODO: Implement C string functions!
ffi.cdef([[
  char *strchr(const char *_Str, int _Val);
  int toupper(int _C);
  int tolower(int _C);
  char *strstr(const char *_Str, const char *_SubStr);
  char *strcat(char *destination, const char *source);
  size_t strlen(const char *_Str);
]])

_C.string.rep = function(s, n, sep)
  local str = ""
  if sep then sp = sep else sp = "" end
  for i = 1, n, 1 do
    if (i == n) then sp = "" end
    str = str..s..sp
  end
  return str
end

_C.string.len = function(s)
  return _C.int(ffi.C.strlen(s))
end

-- TODO: Better string.char
_C.string.char = function(c)
  return ffi.new("char", c)
end

_C.string.byte = function(s, b)
  local t = ffi.new("char[?]", #s)
  ffi.copy(t, s)
  return t[b]
end

_C.string.chartoint = function(c)
  return ffi.new("int", c)
end

_C.string.char_pointer = function(text)
  local t = ffi.new("char[?]", #text)
  ffi.copy(t, text)
  return t
end

_C.string.insert = function(s, str)
  return ffi.string(ffi.C.strcat(s, str))
end

_C.string.reverse = function(s)
  local t = ffi.new("char[?]", #s)
  ffi.copy(t, s)
  local result = {}
  for i = 1, (#s - 1), 1 do
    result[i] = _C.string.char(t[#s - i])
  end
  return _C.table.concat(result, "")
end

_C.string.upper = function(s)
  local t = ffi.new("char[?]", #s)
  ffi.copy(t, s)
  local result = {}
  for i = 1, #s, 1 do
    result[i] = ffi.C.toupper(_C.string.char(_C.int(t[i])))
  end
  return _C.table.concat(result, "")
end

_C.string.lower = function(s)
  local t = ffi.new("char[?]", #s)
  ffi.copy(t, s)
  local result = {}
  for i = 1, #s, 1 do
    result[i] = ffi.C.tolower(_C.string.char(_C.int(t[i])))
  end
  return _C.table.concat(result, "")
end

_C.string.format = function(...)
  local args = { ... }
  if (#args % 2 == 0) then
    return _C.table.unpack(args)
  end
end

_C.string.sub = function(s, f, t)
  local result = ffi.new("char[?]", #s)
  local text = ""
  local nextchr = 0
  local str = ffi.new("char[?]", #s)
  ffi.copy(str, s)
  for i = f, t, 1 do
    text = text..str[f + nextchr]
    nextchr = nextchr + 1
  end
  ffi.copy(result, text)
  return result
end

-- Currently, I wrapped these as they are *something internal*
_C.string.find = string.find
_C.string.match = string.match
_C.string.gmatch = string.gmatch
_C.string.gsub = string.gsub
_C.string.dump = string.dump