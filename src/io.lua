-- Written by Rabia Alhaffar in 24/August/2020
-- IO module
ffi.cdef([[
  struct _iobuf {
    char *_ptr;
    int _cnt;
    char *_base;
    int _flag;
    int _file;
    int _charbuf;
    int _bufsiz;
    char *_tmpfname;
  };
  typedef struct _iobuf FILE;
  
  int fclose(FILE *_File);
  FILE *fopen(const char *_Filename,const char *_Mode);
  int ferror(FILE *_File);
  int fflush(FILE *_File);
  int fgetc(FILE *_File);
  int fputc(int _Ch,FILE *_File);
  FILE *tmpfile(void);
  int scanf(const char *_Format, ...);
  int fprintf(FILE *_File, const char *_Format, ...);
  char *fgets(char *_Buf, int _MaxCount, FILE *_File);
  int fputs(const char *_Str, FILE *_File);
  char *gets(char *_Buffer);
  int puts(const char *_Str);
  int fflush(FILE *_File);
  FILE *_popen(const char *_Command, const char *_Mode);
  int feof(FILE *_File);
  int fseek(FILE *stream, long int offset, int whence);
  size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
  char *fgets(char *_Buf, int _MaxCount, FILE *_File);
  int fscanf(FILE *_File, const char *_Format, ...);
]])

_C.io = {}
_C.io.stdin = io.stdin
_C.io.stdout = io.stdout
_C.io.stderr = io.stderr
_C.io.open = ffi.C.fopen
_C.io.write = ffi.C.fprintf
_C.io.close = ffi.C.fclose
_C.io.flush = ffi.C.fflush
_C.io.tmpfile = ffi.C.tmpfile
_C.io.popen = ffi.C._popen

-- NOTES: io.read() still in development, But should works!
_C.io.read = function(...)
  local args = { ... }
  if (#args == 0) then
    local v = ffi.new("char[?]", 10000)
    ffi.C.scanf("%[^\n]%*c", v)
    return _C.cstring(v)
  else
    if (type(args[1]) == "cdata") then
      local m = args[2]
      if (m == "*n") or (m == "*number") or (m == "n") or (m == "number") then
        local result = ffi.new("char[?]", 1000)
        ffi.C.fscanf(args[1], "%[^\n]", result)
        if (type(_C.tonumber(result)) == "number") and (_C.tonumber(result) > 0) or (_C.tonumber(result) < 0) then
          return _C.tonumber(_C.cstring(result))
        end
      elseif (m == "*a") or (m == "*all") or (m == "a") or (m == "all") then
        local text = ffi.new("char[?]", 1000000)
        local result = ffi.new("char[?]", 1000000)
        while not (ffi.C.fgets(text, 1000000, args[1])) do
          ffi.copy(result, text)
        end
        return _C.cstring(result)
      elseif (m == "*l") or (m == "*line") or (m == "l") or (m == "line") then
        local result = ffi.new("char[?]", 1000)
        ffi.C.fscanf(args[1], "%[^\n]", result)
        return _C.cstring(result)
      elseif (m <= 0) or (m >= 0) then
        local bytes = ffi.new("char[?]", args[3])
        ffi.C.fread(bytes, 1, m, args[1])
        return _C.cstring(bytes)
      else
        return 0
      end
    else
      ffi.C.scanf(...)
    end
  end
end

_C.io.lines = function(f)
  local l = 0
  while not (ffi.C.feof(f)) do
    local ch = ffi.C.fgetc(f)
    if (ch == "\n") then
      l = l + 1
    end
  end
  return _C.tonumber(_C.int(l))
end

_C.io.seek = function(f, w, o)
  if (w == "set") then
    ffi.C.fseek(f, o, 0)
  elseif (w == "cur") then
    ffi.C.fseek(f, o, 1)
  elseif (w == "end") then
    ffi.C.fseek(f, o, 2)
  else
    ffi.C.fseek(f, o, w)
  end
end