# CLua Lua API

Here is list of available functions, Note that i recommend reading [official Lua reference manual](https://www.lua.org/manual/5.3/manual.html) before trying to understand this.

- [ctypes](#ctypes)
- [runtime](#runtime)
- [math](#math)
- [os](#os)
- [io](#io)
- [string](#string)
- [table](#table)
- [coroutine](#coroutine)
- [bit](#bit)
- [utf8](#utf8)
- [package](#package)
- [ffi](#ffi)
- [debug](#debug)
- [repl](#repl)

### ctypes

```lua
_C.TRUE
_C.FALSE
_C.NULL
_C.NUL

_C.int(n)
_C.float(n)
_C.double(n)
_C.uint(n)
_C.ufloat(n)
_C.uint_long_long(n)
_C.char(c)
_C.cstring(s)
_C.array(ctype, size)
_C.array(ctype, content)
```

### runtime

```lua
_C.print(format, ...)
_C.tonumber(str)
_C.super_next(t, k)
_C.next(t, k)
_C.tostring(n)
_C.error(msg, code)
_C.super_ipairs(...)
_C.iterate(t, i)
_C.ipairs(t)
_C.pairs(t)
_C.assert(v, msg)
_C.super_type(v, t)
_C.loadstring(str)
_C.loadfile(path)
_C.dofile(path)
_C.rawlen(o)
_C.rawget(t, i)
_C.rawset(t, i, v)
_C.rawequal(a, b)
_C.pcall(f, ...)
_C.xpcall(f, msgh, ...)
_C.setenv(t)
_C.require(m)
_C.getmetatable(o)
_C.getmetatable(t, mt)
```

### math

``lua
_C.math.abs(a)
_C.math.acos(a)
_C.math.asin(a)
_C.math.atan(a)
_C.math.atan(a, b)
_C.math.sinh(a)
_C.math.cosh(a)
_C.math.tanh(a)
_C.math.cos(a)
_C.math.exp(a)
_C.math.ceil(a)
_C.math.fabs(a)
_C.math.floor(a)
_C.math.fmod(a, b)
_C.math.log(a)
_C.math.log10(a)
_C.math.logb(a)
_C.math.fmod(a, b)
_C.math.ldexp(a, b)
_C.math.frexp(a, b)
_C.math.modf(a, b)
_C.math.pi
_C.math.mininteger
_C.math.maxinteger
_C.math.huge
_C.math.sin(a)
_C.math.sqrt(a)
_C.math.tan(a)
_C.math.pow(a, n)
_C.math.hypot(x, y)
_C.math.finite(n)
_C.math.isnan(n)
_C.math.deg(r)
_C.math.rad(d)
_C.math.max(x, y)
_C.math.min(x, y)
_C.math.ult(m, n)
_C.math.randomseed(x)
_C.math.random()
_C.math.random(a)
_C.math.random(a, b)
_C.math.tointeger(n)
```

### os

```lua
_C.os.time()
_C.os.execute(command)
_C.os.exit(code)
_C.os.rename(old_filename, new_filename)
_C.os.remove(filename)
_C.os.getenv(varname)
_C.os.setlocale(category, locale)
_C.os.difftime(time1, time2)
_C.os.tmpname(buffer)
_C.os.date(buffer)
_C.os.clock()
```

### io

```lua
_C.io.stdin
_C.io.stdout
_C.io.stderr
_C.io.open(filename, mode)
_C.io.write(file, format, ...)
_C.io.close(file)
_C.io.flush(file)
_C.io.tmpfile()
_C.io.popen(command, mode)
_C.io.read()
_C.io.read(file, mode)
_C.io.read(...)
_C.io.lines(file)
_C.io.seek(file, w, o)
```

### string

```lua
_C.string.rep(str, n, sep)
_C.string.len(str)
_C.string.char(c)
_C.string.byte(str, byte)
_C.string.chartoint(c)
_C.string.char_pointer(text)
_C.string.insert(str1, str2)
_C.string.reverse(str)
_C.string.upper(str)
_C.string.lower(str)
_C.string.format(...)
_C.string.sub(str, from, to)

-- Currently, I wrapped these as they are *something internal*
_C.string.find = string.find
_C.string.match = string.match
_C.string.gmatch = string.gmatch
_C.string.gsub = string.gsub
_C.string.dump = string.dump
```

### table

``lua
_C.table.remove(t, i)
_C.table.insert(t, i)
_C.table.concat(t, s)
_C.table.shuffle(t)
_C.table.unpack(t, i)
_C.table.pack(...)
_C.table.sort(t)
_C.table.move(t1, f, e, t, t2)
```

### coroutine

```lua
_C.coroutine.coroutines
_C.coroutine.create(f, resume_limit)
_C.coroutine.kill(c)
_C.coroutine.running(c)
_C.coroutine.isyieldable(c)
_C.coroutine.resume(c, ...)
_C.coroutine.yield(c, ...)
_C.coroutine.get(i)
_C.coroutine.status(c)
_C.coroutine.wrap(f, resume_limit)
```

### bit

```lua
_C.bit.bits
_C.bit.powtab
_C.bit.band(a, b)
_C.bit.bor(a, b)
_C.bit.bxor(a, b)
_C.bit.bnot(a)
_C.bit.lshift(a, n)
_C.bit.rshift(a, n)
_C.bit.arshift(a, n)
```

### utf8

```lua
_C.utf8.charpattern
_C.utf8.offsets
_C.utf8.bytes
_C.utf8.isutf(c)
_C.utf8.nextchar(s, i)
_C.utf8.codepoint(s, offset)
_C.utf8.len(s)
_C.utf8.offset(str, charnum)
_C.utf8.codes(s)
_C.utf8.char(dest, sz, src, srcsz)
```

### package

```lua
_C.package.loaddir
_C.package.config
_C.package.path
_C.package.cpath
_C.package.loaded
_C.package.loadlib(libname, funcname)
_C.package.searchers
_C.package.searchpath(name, path [, sep [, rep]])
```

### ffi

See FFI API from [here](https://luajit.org/ext_ffi_api.html), Same but with `_C` namespace, As other CLua modules follows this concept!

### debug

```lua
_C.debug.enabled
_C.debug.debug()
_C.debug.getmetatable(o)
_C.debug.getmetatable(t, mt)
_C.debug.getuservalue(u)
_C.debug.setuservalue(v, u)
_C.debug.traceback(f)
_C.debug.gethook([thread])
_C.debug.getinfo([thread,] f [, what])
_C.debug.getlocal([thread,] f, local)
_C.debug.getregistry()
_C.debug.getupvalue(f, up)
_C.debug.sethook([thread,] hook, mask [, count])
_C.debug.setlocal([thread,] level, local, value)
_C.debug.setupvalue(f, up, value)
_C.debug.upvalueid(f, n)
_C.debug.upvaluejoin(f1, n1, f2, n2)
```

### repl

```lua
_C.repl.enabled
_C.repl.run()
```