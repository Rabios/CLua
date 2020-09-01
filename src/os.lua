-- Written by Rabia Alhaffar in 24/August/2020
-- OS module
_C.os = {}

ffi.cdef([[
  typedef long clock_t;
  int system(const char *_Command);
  void exit(int _Code);
  int remove(const char *_Filename);
  int rename(const char *_OldFilename, const char *_NewFilename);
  char *setlocale(int _Category, const char *_Locale);
  char *getenv(const char *_VarName);
  double difftime(time_t _Time1, time_t _Time2);
  char tmpnam(char *_Buffer);
  clock_t clock(void);
  char *_strdate(char *_Buffer);
]])
  
_C.os.time = function()
  return ffi.C.time(ffi.new("time_t *"))
end

_C.os.execute = ffi.C.system
_C.os.exit = ffi.C.exit
_C.os.rename = ffi.C.rename
_C.os.remove = ffi.C.remove
_C.os.getenv = ffi.C.getenv
_C.os.setlocale = ffi.C.setlocale
_C.os.difftime = ffi.C.difftime
_C.os.tmpname = ffi.C.tmpnam
_C.os.date = ffi.C._strdate
_C.os.clock = ffi.C.clock