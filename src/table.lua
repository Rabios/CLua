-- Written by Rabia Alhaffar in 24/August/2020
-- table module
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