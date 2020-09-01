-- You can still use default ipairs :)
-- However, Here is examples shows using it!
local _C = require("clua")

local arr = { 1, 2, 3, 4, 5 }
local k = 0

-- If you add that true as 4th parameter, table will flush (Will become nil and all other stuff deleted)
_C.super_ipairs(k, arr, function(k)
  _C.print("%d\n", _C.int(arr[k])) --> 1, 2, 3, 4, 5
end, true)