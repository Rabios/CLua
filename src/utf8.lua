-- Written by Rabia Alhaffar in 27/August/2020
-- UTF8 module, WARNING: Still experimental and might face bugs!
ffi.cdef([[
  typedef unsigned int uint32_t;
  typedef uint32_t u_int32_t;
]])

_C.utf8 = {}
_C.utf8.charpattern = "[\0-\x7F\xC2-\xF4][\x80-\xBF]*"
_C.utf8.offsets = ffi.new("u_int32_t[6]", 0x00000000, 0x00003080, 0x000E2080, 0x03C82080, 0xFA082080, 0x82082080)
_C.utf8.bytes = ffi.new("char[256]")

local col = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5 }

for b in _C.ipairs(col, b) do
  _C.utf8.bytes[b] = col[b]
end

-- Functions came from "Basic UTF-8 manipulation routines" by Jeff Bezanson but ported to LuaJIT!
-- https://www.cprogramming.com/tutorial/unicode.html
-- NOTES: I'm not sure if _C.utf8.codes and _C.utf8.char works!
_C.utf8.isutf = function(c)
  return not (bit.band(c, 0xC0) == 0x80)
end

_C.utf8.nextchar = function(s, i)
  local ch = ffi.new("u_int32_t", 0)
  local sz = 0
  while (s[i] and not _C.utf8.isutf(s[i])) do
    ch = bit.lshift(ch, 6)
    ch = ch + ffi.new("unsigned char", s[i + 1])
    sz = sz + 1
  end
  ch = ch - _C.utf8.offsets[sz - 1]
  return ch
end

_C.utf8.codepoint = function(s, offset)
  local charnum = 0
  local offs = 0

  while (offs < offset and s[offs]) do
    offs = offs + 1
    if _C.utf8.isutf(s[offs]) or _C.utf8.isutf(s[offs]) or _C.utf8.isutf(s[offs]) or offs then
      charnum = charnum + 1
    end
  end
  
  return charnum
end

_C.utf8.len = function(s)
  local count = 0
  local i = 0
  while not _C.utf8.nextchar(s, i) == 0 do
    count = count + 1
  end
  return count
end

_C.utf8.offset = function(str, charnum)
  local offset = 0

  while (charnum > 0 and str[offset]) do
    offset = offset + 1
    if _C.utf8.isutf(str[offset]) or _C.utf8.isutf(str[offset]) or _C.utf8.isutf(str[offset]) or offset then
      charnum = charnum - 1
    end
  end
    
  return offset
end

_C.utf8.codes = function(s)
  local ch = ffi.new("u_int32_t")
  local src_end = ffi.string(src + srcsz)
  local nb = 0
  local i = 0
  while (i < sz - 1) do
    nb = _C.utf8.bytes[src]
    if (srcsz == -1) then
      if (src == 0) then
        goto done_toucs
      end
    else
      if (src + nb >= src_end) then
        goto done_toucs
      end
      ch = 0
      if (nb == 3) then
        ch = ch + ffi.new("unsigned char", src + 1)
        ch = bit.lshift(ch, 6)
      elseif (ch == 2) then
        ch = ch + ffi.new("unsigned char", src + 1)
        ch = bit.lshift(ch, 6)
      elseif (ch == 1) then
        ch = ch + ffi.new("unsigned char", src + 1)
        ch = bit.lshift(ch, 6)
      elseif (ch == 0) then
        ch = ch + ffi.new("unsigned char", src + 1)
      end
      ch = ch - _C.utf8.offsets[nb]
      dest[i + 1] = ch
    end
  end
  ::done_toucs::
    dest[i] = 0
    return i
end

_C.utf8.char = function(dest, sz, src, srcsz)
  local ch = ffi.new("u_int32_t")
  local i = 0
  local dest_end = ffi.string(dest + sz)
  local cond = _C.ternary((srcsz < 0), src[i] ~= 0, i < srcsz)
  while (cond) do
    ch = src[i]
    if (ch < 0x80) then
      if (dest >= dest_end) then
        return i
      end
      dest = dest + 1
      dest = ch
    elseif (ch < 0x800) then
      if (dest >= dest_end - 1) then
        return i
      end
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.rshift(ch, 6), 0xC0)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(ch, 0x3F), 0x80)
    elseif (ch < 0x10000) then
      if (dest >= dest_end - 2) then
        return i
      end
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.rshift(ch, 12), 0xE0)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(_C.bit.rshift(ch, 6), 0x3F), 0x80)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(ch, 0x3F), 0x80)
    elseif (ch < 0x110000) then
      if (dest >= dest_end - 3) then
        return i
      end
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.rshift(ch, 18), 0xF0)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(_C.bit.rshift(ch, 12), 0x3F), 0x80)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(_C.bit.rshift(ch, 6), 0x3F), 0x80)
      dest = dest + 1
      dest = _C.bit.bor(_C.bit.band(ch, 0x3F), 0x80)
    end
    i = i + 1
  end
  if (dest < dest_end) then
    dest = '\0'
  end
  return i
end