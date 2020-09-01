-- Written by Rabia Alhaffar in 24/August/2020
-- Same LuaJIT FFI module with some minor changes if found
_C.ffi = {}
_C.ffi.C = ffi.C
_C.ffi.cdef = ffi.cdef
_C.ffi.load = ffi.load
_C.ffi.new = ffi.new
_C.ffi.typeof = ffi.typeof
_C.ffi.cast = ffi.cast
_C.ffi.metatype = ffi.metatype
_C.ffi.gc = ffi.gc
_C.ffi.sizeof = ffi.sizeof
_C.ffi.alignof = ffi.alignof
_C.ffi.offsetof = ffi.offsetof
_C.ffi.istype = ffi.istype
_C.ffi.errno = ffi.errno

_C.ffi.string = function(s)
  local str = ffi.new("char[?]", #s)
  ffi.copy(str, s)
  return s
end

_C.ffi.copy = ffi.copy
_C.ffi.fill = ffi.fill
_C.ffi.abi = ffi.abi
_C.ffi.os = ffi.os

-- https://stackoverflow.com/a/61326632
_C.ffi.arch = _C.ternary((0xfffffffff == 0xffffffff), "x86", "x64")