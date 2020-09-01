-- Written by Rabia Alhaffar in 28/August/2020
-- Simple REPL for CLua, %100 works!
_C.repl = {}
_C.repl.enabled = false

_C.repl.run = function()
  _C.print("%s", _C._VERSION.." ".._C._CODENAME.." REPL"..", Copyright".." (c) ".._C._COPYRIGHT_DATE.." by ".._C._AUTHOR..", ".._C._URL.."\n")
  _C.print("%s", "> ")
  while _C.repl.enabled do
    local command = _C.io.read()
    if _C.assert(_C.loadstring(command), "Syntax error!") then
      _C.loadstring(command)()
    end
    _C.print("\n%s", "> ")
  end
end