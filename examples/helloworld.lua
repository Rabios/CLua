-- Simple hello world example for CLua
local _C = require("clua")
_C.print("%s", "Hello world") -- NOTE: CLua uses printf with C formatting to print instead of Lua print!
