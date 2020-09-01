-- Written by Rabia Alhaffar in 24/August/2020
-- math library
_C.math = {}

ffi.cdef([[
  double sin (double);
  double cos (double);
  double tan (double);
  double sinh (double);
  double cosh (double);
  double tanh (double);
  double asin (double);
  double acos (double);
  double atan (double);
  double atan2 (double, double);
  double exp (double);
  double log (double);
  double log10 (double);
  double pow (double, double);
  double sqrt (double);
  double ceil (double);
  double floor (double);
  double fabs (double);
  double ldexp (double, int);
  double frexp (double, int*);
  double modf (double, double*);
  double fmod (double, double);

  double _hypot (double, double);
  double _logb (double);
  int _finite (double);
  int _isnan (double);

  int rand(void);
  void srand(unsigned int _Seed);
  enum { RAND_MAX = 32767 };
  typedef long __time32_t;
  typedef long long int __time64_t;
]])

if ffi.arch == "x86" then
  ffi.cdef("typedef __time32_t time_t;")
elseif ffi.arch == "x64" then
  ffi.cdef("typedef __time64_t time_t;")
end

ffi.cdef([[
  time_t time(time_t *_Time);
  char * ctime(const time_t *_Time);
]])

-- Implement math library from C code!
_C.math.abs = ffi.C.fabs
_C.math.acos = ffi.C.acos
_C.math.asin = ffi.C.asin

-- For compatibility ;)
_C.math.atan = function(...)
  local args = { ... }
  if (#args == 1) then
    return ffi.C.atan(args[1])
  elseif (#args == 2) then
    return ffi.C.atan2(args[1], args[2])
  end
end

_C.math.atan2 = ffi.C.atan2
_C.math.sinh = ffi.C.sinh
_C.math.cosh = ffi.C.cosh
_C.math.tanh = ffi.C.tanh
_C.math.cos = ffi.C.cos
_C.math.exp = ffi.C.exp
_C.math.ceil = ffi.C.ceil
_C.math.fabs = ffi.C.fabs
_C.math.floor = ffi.C.floor
_C.math.fmod = ffi.C.fmod
_C.math.log = ffi.C.log
_C.math.log10 = ffi.C.log10
_C.math.logb = ffi.C._logb
_C.math.fmod = ffi.C.fmod
_C.math.ldexp = ffi.C.ldexp
_C.math.frexp = ffi.C.frexp
_C.math.modf = ffi.C.modf
_C.math.pi = 3.14159265358979323846
_C.math.mininteger = -2147483648
_C.math.maxinteger = 2147483647
_C.math.huge = 1 / 0
_C.math.sin = ffi.C.sin
_C.math.sqrt = ffi.C.sqrt
_C.math.tan = ffi.C.tan
_C.math.pow = ffi.C.pow
_C.math.hypot = ffi.C._hypot
_C.math.finite = ffi.C._finite
_C.math.isnan = ffi.C._isnan

_C.math.deg = function(r)
  return r * (_C.float(180.0) / _C.math.pi)
end

_C.math.rad = function(d)
  return d * (_C.math.pi / _C.float(180.0))
end

_C.math.max = function(x, y)
  if (x > y) then
    return x
  else
    return y
  end
end

_C.math.min = function(x, y)
  if (x < y) then
    return x
  else
    return y
  end
end

_C.math.ult = function(m, n)
  return ffi.new("unsigned int", m) < ffi.new("unsigned int", n)
end

_C.math.randomseed = function(x)
  ffi.C.srand(x)
end

_C.math.random = function(...)
  local r = { ... }
  if (#r == 0) then
    return ffi.C.rand() % 0
  elseif (#r == 1) then
    return ffi.C.rand() % r[1]
  elseif (#r == 2) then
    return _C.math.floor(ffi.C.rand() % r[2]) + r[1]
  end
  r = nil
end

_C.math.tointeger = function(n)
  return math.floor(n)
end