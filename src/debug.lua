-- Written by Rabia Alhaffar in 30/August/2020
-- Debug module
ffi.cdef("int vsnprintf(char *, size_t, const char *, va_list);")
_C.debug = {}
_C.debug.enabled = false

_C.debug.debug = function()
  if not _C.debug.enabled then
    if not _C.repl.enabled then
      _C.debug.enabled = true
      _C.repl.enabled = true
      _C.repl.run()
    end
  else
    _C.debug.enabled = false
    _C.repl.enabled = false
  end
end

_C.debug.getmetatable = getmetatable
_C.debug.setmetatable = setmetatable

_C.debug.getuservalue = function(u)
  if (type(u) == "userdata") then
    return u
  end
end

_C.debug.setuservalue = function(v, u)
  if (type(u) == "userdata") then
    u = v
  end
end

-- Implementation got it from SetTraceLogCallback raylua implementation, All thanks goes to Astie Teddy (@TSnake41)
_C.debug.traceback = __tracelog__
function __tracelog__(callback)
  _C.debug.traceback(function (level, text, args)
    local buffer = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buffer, 512, text, args)
    callback(level, ffi.string(buffer))
  end)
end

-- Wrap, Currently these are something internal that i look for a way to rewrite them (And may fail to find one)
_C.debug.gethook = debug.gethook
_C.debug.getinfo = debug.getinfo
_C.debug.getlocal = debug.getlocal
_C.debug.getregistry = debug.getregistry
_C.debug.getupvalue = debug.getupvalue
_C.debug.sethook = debug.sethook
_C.debug.setlocal = debug.setlocal
_C.debug.setupvalue = debug.setupvalue
_C.debug.upvalueid = debug.upvalueid
_C.debug.upvaluejoin = debug.upvaluejoin