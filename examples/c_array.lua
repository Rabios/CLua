local _C = require("clua")

-- Length in C array defined automatically by function ;)
local c_array = _C.array("int", 100, 200, 300, 400, 500)

for ca in _C.ipairs(c_array, ca) do
  _C.print("%d", _C.int(c_array[ca]))
end