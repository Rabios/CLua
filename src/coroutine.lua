-- Written by Rabia Alhaffar in 27/August/2020
-- Coroutine module
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