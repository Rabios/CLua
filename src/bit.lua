-- Written by Rabia Alhaffar in 24/August/2020
-- Based on bitlib and LuaBit (Lua libraries)
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