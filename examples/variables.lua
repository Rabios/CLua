-- This example shows merging FFI with local variables
local _C = require("clua")

local a = _C.int(10)
local b = 10
print("%d", a + b)