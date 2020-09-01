-- CLua, Reimplementation of Lua in LuaJIT with C functions using FFI!
-- Version: v0.1, Built in: 1/September/2020
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

-- NOTES: I don't assume that it's a full implementation of Lua
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

_C.os = {}

ffi.cdef([[
  typedef long clock_t;
  int system(const char *_Command);
  void exit(int _Code);
  int remove(const char *_Filename);
  int rename(const char *_OldFilename, const char *_NewFilename);
  char *setlocale(int _Category, const char *_Locale);
  char *getenv(const char *_VarName);
  double difftime(time_t _Time1, time_t _Time2);
  char tmpnam(char *_Buffer);
  clock_t clock(void);
  char *_strdate(char *_Buffer);
]])
  
_C.os.time = function()
  return ffi.C.time(ffi.new("time_t *"))
end

_C.os.execute = ffi.C.system
_C.os.exit = ffi.C.exit
_C.os.rename = ffi.C.rename
_C.os.remove = ffi.C.remove
_C.os.getenv = ffi.C.getenv
_C.os.setlocale = ffi.C.setlocale
_C.os.difftime = ffi.C.difftime
_C.os.tmpname = ffi.C.tmpnam
_C.os.date = ffi.C._strdate
_C.os.clock = ffi.C.clock

ffi.cdef([[
  struct _iobuf {
    char *_ptr;
    int _cnt;
    char *_base;
    int _flag;
    int _file;
    int _charbuf;
    int _bufsiz;
    char *_tmpfname;
  };
  typedef struct _iobuf FILE;
  
  int fclose(FILE *_File);
  FILE *fopen(const char *_Filename,const char *_Mode);
  int ferror(FILE *_File);
  int fflush(FILE *_File);
  int fgetc(FILE *_File);
  int fputc(int _Ch,FILE *_File);
  FILE *tmpfile(void);
  int scanf(const char *_Format, ...);
  int fprintf(FILE *_File, const char *_Format, ...);
  char *fgets(char *_Buf, int _MaxCount, FILE *_File);
  int fputs(const char *_Str, FILE *_File);
  char *gets(char *_Buffer);
  int puts(const char *_Str);
  int fflush(FILE *_File);
  FILE *_popen(const char *_Command, const char *_Mode);
  int feof(FILE *_File);
  int fseek(FILE *stream, long int offset, int whence);
  size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
  char *fgets(char *_Buf, int _MaxCount, FILE *_File);
  int fscanf(FILE *_File, const char *_Format, ...);
]])

_C.io = {}
_C.io.stdin = io.stdin
_C.io.stdout = io.stdout
_C.io.stderr = io.stderr
_C.io.open = ffi.C.fopen
_C.io.write = ffi.C.fprintf
_C.io.close = ffi.C.fclose
_C.io.flush = ffi.C.fflush
_C.io.tmpfile = ffi.C.tmpfile
_C.io.popen = ffi.C._popen

-- NOTES: io.read() still in development, But should works!
_C.io.read = function(...)
  local args = { ... }
  if (#args == 0) then
    local v = ffi.new("char[?]", 10000)
    ffi.C.scanf("%[^\n]%*c", v)
    return _C.cstring(v)
  else
    if (type(args[1]) == "cdata") then
      local m = args[2]
      if (m == "*n") or (m == "*number") or (m == "n") or (m == "number") then
        local result = ffi.new("char[?]", 1000)
        ffi.C.fscanf(args[1], "%[^\n]", result)
        if (type(_C.tonumber(result)) == "number") and (_C.tonumber(result) > 0) or (_C.tonumber(result) < 0) then
          return _C.tonumber(_C.cstring(result))
        end
      elseif (m == "*a") or (m == "*all") or (m == "a") or (m == "all") then
        local text = ffi.new("char[?]", 1000000)
        local result = ffi.new("char[?]", 1000000)
        while not (ffi.C.fgets(text, 1000000, args[1])) do
          ffi.copy(result, text)
        end
        return _C.cstring(result)
      elseif (m == "*l") or (m == "*line") or (m == "l") or (m == "line") then
        local result = ffi.new("char[?]", 1000)
        ffi.C.fscanf(args[1], "%[^\n]", result)
        return _C.cstring(result)
      elseif (m <= 0) or (m >= 0) then
        local bytes = ffi.new("char[?]", args[3])
        ffi.C.fread(bytes, 1, m, args[1])
        return _C.cstring(bytes)
      else
        return 0
      end
    else
      ffi.C.scanf(...)
    end
  end
end

_C.io.lines = function(f)
  local l = 0
  while not (ffi.C.feof(f)) do
    local ch = ffi.C.fgetc(f)
    if (ch == "\n") then
      l = l + 1
    end
  end
  return _C.tonumber(_C.int(l))
end

_C.io.seek = function(f, w, o)
  if (w == "set") then
    ffi.C.fseek(f, o, 0)
  elseif (w == "cur") then
    ffi.C.fseek(f, o, 1)
  elseif (w == "end") then
    ffi.C.fseek(f, o, 2)
  else
    ffi.C.fseek(f, o, w)
  end
end

_C.table = {}

_C.table.remove = function(t, i)
  t[i] = nil
end

_C.table.insert = function(t, i)
  t[#t + 1] = i
end

_C.table.concat = function(t, s)
  local result = ""
  for str in _C.ipairs(t, str) do
    if (type(t[str]) == "string") then
      if (str == #t) then s = "" end
      result = result..(t[str]..s)
    elseif (type(t[str]) == "number") then
      if (str == #t) then s = "" end
      result = result..(_C.tostring(t[str])..s)
    end
  end
  return result
end

_C.table.shuffle = function(t)
  local result = {}
  _C.math.randomseed(_C.os.time())
  for i in _C.ipairs(t, i) do
    result[_C.math.random(1, i)] = t[_C.math.random(1, i)]
  end
  return result
end

-- This function implemented from link below!
-- http://www.lua.org/pil/5.1.html
_C.table.unpack = function(t, i)
  i = i or 1
  if (t[i] ~= nil) then
    return t[i], _C.table.unpack(t, i + 1)
  end
end

_C.table.pack = function(...)
  return { ... }
end

-- https://rosettacode.org/wiki/Sorting_algorithms/Quicksort#non_in-place
_C.table.sort = function(t)
  if #t < 2 then return t end
  local pivot = t[1]
  if (type(pivot) == "string") then pivot = #t[1] end
  local a, b, c = {}, {}, {}
  for _, v in ipairs(t) do
    if (type(v) == "number") then
      if v < pivot then
        a[#a + 1] = v
      elseif v > pivot then
        c[#c + 1] = v
      else
        b[#b + 1] = v
      end
    elseif (type(v) == "string") then
      if #v < pivot then
        a[#a + 1] = v
      elseif #v > pivot then
        c[#c + 1] = v
      else
        b[#b + 1] = v
      end
    end
  end
  a = _C.table.sort(a)
  c = _C.table.sort(c)
  for _, v in ipairs(b) do a[#a + 1] = v end
  for _, v in ipairs(c) do a[#a + 1] = v end
  return a
end

_C.table.move = function(t1, f, e, t, t2)
  local nums = (e - 1)
  for i = 0, nums, 1 do
    t2[t + i] = t1[f + i]
  end
end

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

_C.coroutine = {}
_C.coroutine.coroutines = {} -- To store coroutines ;)

_C.coroutine.create = function(f, r)
  _C.coroutine.coroutines[#_C.coroutine.coroutines + 1] = {
    fun = f,
    dead = false,
    running_times = 0,
    running_limit = r,
    yield_args = nil,
    status = "normal",
    thread = true
  }
end

_C.coroutine.kill = function(c)
  if not c.dead then
    c.dead = true
    c.running_times = nil
    c.running_limit = nil
    c.status = "dead"
    c.fun = nil
    c.yield_args = nil
    c.thread = true
  end
end

_C.coroutine.running = function(c)
  if not c.dead then
    return (c.status == "running")
  end
end

_C.coroutine.isyieldable = function(c)
  if not c.dead and (#_C.coroutine.coroutines >= 1) then
    return (not c == _C.coroutine.coroutines[1])
  end
end

_C.coroutine.resume = function(c, ...)
  if (not c.dead) or (c.status == "suspended" or c.status == "normal") then
    c.fun(...)
    c.status = "running"
    local ccount = 1
    local running_coroutines = 0
    _C.ipairs(ccount, _C.coroutine.coroutines, function(ccount)
      if (_C.coroutine.coroutines[ccount].status == "running") then
        running_coroutines = running_coroutines + 1
      end
    end)
    if (running_coroutines > 1) then c.status = "normal" end
    if (c.running_times == c.running_limit) then
      _C.coroutine.kill(c)
    else
      c.running_times = c.running_times + 1
    end
    if (not c.yield_args == nil) then return c.yield_args end
    ccount = nil
    running_coroutines = nil
  end
end

-- TODO: Add extra arguments for _C.coroutine.resume via _C.coroutine.yield
_C.coroutine.yield = function(c, ...)
  if not c.dead and (c.status == "running") then
    c.status = "suspended"
    c.yield_args = { ... }
  end
end

_C.coroutine.get = function(i)
  return _C.coroutine.coroutines[i]
end

_C.coroutine.status = function(c)
  return c.status
end

-- Currently this is a wrap, But i might do stuff based on coroutine.create :)
_C.coroutine.wrap = _C.coroutine.create

-- Special thanks to Diego Martínez for bitty (I used bnot from bitty)
-- https://stackoverflow.com/questions/1449260/bitwise-operations-without-bitwise-operators
-- https://stackoverflow.com/questions/2982729/is-it-possible-to-implement-bitwise-operators-using-integer-arithmetic
_C.bit = {}
_C.bit.bits = 32
_C.bit.powtab = { 1 }

for b = 1, (_C.bit.bits - 1), 1 do
  _C.bit.powtab[#_C.bit.powtab + 1] = _C.math.pow(2, b)
end

_C.bit.band = function(a, b)
  local result = 0
  for x = 1, _C.bit.bits, 1 do
    result = result + result
    if (a < 0) then
      if (b < 0) then
        result = result + 1
      end
    end
    a = a + a
    b = b + b
  end
  return result
end

_C.bit.bor = function(a, b)
  local result = 0
  for x = 1, _C.bit.bits, 1 do
    result = result + result
    if (a < 0) then
      result = result + 1
    elseif (b < 0) then
      result = result + 1
    end
    a = a + a
    b = b + b
  end
  return result
end

_C.bit.bxor = function(a, b)
  local result = 0
  for x = 1, _C.bit.bits, 1 do
    result = result + result
    if (a < 0) then
      if (b >= 0) then
        result = result + 1
      end
    elseif (b < 0) then
      result = result + 1
    end
    a = a + a
    b = b + b
  end
  return result
end

_C.bit.bnot = function(a)
  return _C.bit.bxor(x, (2 ^ (_C.bit.bits or _C.math.floor(_C.math.log(x, 2)))) - 1)
end

_C.bit.lshift = function(a, n)
  if (n > _C.bit.bits) then
    a = 0
  else
    a = a * _C.bit.powtab[n]
  end
  return a
end

_C.bit.rshift = function(a, n)
  if (n > _C.bit.bits) then
    a = 0
  elseif (n > 0) then
    if (a < 0) then
      a = a + -_C.bit.powtab[#_C.bit.powtab]
      a = a / _C.bit.powtab[n]
      a = a + _C.bit.powtab[_C.bit.bits - n]
    else
      a = a / _C.bit.powtab[n]
    end
  end
  return a
end

_C.bit.arshift = function(a, n)
  if (n >= _C.bit.bits) then
    if (a < 0) then
      a = -1
    else
      a = 0
    end
  elseif (n > 0) then
    if (a < 0) then
      a = a + -_C.bit.powtab[#_C.bit.powtab]
      a = a / _C.bit.powtab[n]
      a = a - _C.bit.powtab[_C.bit.bits - n]
    else
      a = a / _C.bit.powtab[n]
    end
  end
  return a
end

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

_C.repl = {}
_C.repl.enabled = false

_C.repl.run = function()
  _C.print("%s", _C._VERSION.." ".._C._CODENAME.." REPL"..", Copyright".." (c) ".._C._COPYRIGHT_DATE.." by ".._C._AUTHOR..", ".._C._URL.."\n")
  _C.print("%s", "> ")
  while _C.repl.enabled do
    local command = _C.io.read()
    if _C.assert(_C.loadstring(command), "Syntax error!") then
      _C.loadstring(command)()
    end
    _C.print("\n%s", "> ")
  end
end

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
