local _C = require("clua")

-- Welcome to CLua!
-- CLua is implementation of Lua functions that use C or Lua code from zero!
-- CLua primer will take you in experience of C-based Lua code, Get ready!

-- If you have experience with Lua and small or few knowledge of C programming, You can continue :)
-- These are list of some changes

-- First: printing
-- Printing in CLua uses printf, So it's pretty to see C here!
_C.print("%s", "Hello world!\n") --> Hello world!

-- Second: variables
-- You can create variables with default Lua way, Or the master way (FFI)
local a = 10         --> 10 (Default way)
local b = _C.int(10) --> 10 (Uses LuaJIT FFI to create C integer)

_C.print("%d\n", a + b) --> You can do this! :)

-- Third: ipairs
-- ipairs here changed by the way
local count = 0
local arr = { 1, 2, 3, 4, 5 }
_C.super_ipairs(count, arr, function(count) -- You should do this!
    
  -- I added _C.tonumber with _C.int in case that someone uses string
  _C.print("%d\n", _C.int(arr[count])) --> 1, 2, 3, 4, 5

end, true) -- This true means that you can nil tables to offer performance when loop finishes, In case you don't want to use them later

_C.print("%d\n", arr[2]) --> nil, Set true above to false (Or remove it) to print value of table index 2 :)

-- Fourth: Conversion
local strnum = "100"
local inttostr = 100
_C.print("%d\n", _C.int(_C.tonumber(strnum)))
_C.print("%s\n", _C.tostring(inttostr))

-- Fifth: Reading
_C.print("%s", "Enter 1st number: ")
local c = _C.io.read()

_C.print("%s", "Enter 2nd number: ")
local d = _C.io.read()

_C.print("%s", "Summary of the 2 numbers is: ")
_C.print("%d", _C.int(_C.tonumber(c) + _C.tonumber(d)))