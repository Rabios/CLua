local _C = require("clua")

local f = _C.io.open("98.txt", "w")
_C.io.write(f, "%s", "This is 98!")
_C.io.close(f)

-- Log
_C.print("%s", "LOG: FILE WRITTEN SUCCESSFULLY!")