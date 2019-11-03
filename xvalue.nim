type
  VALUE_RESULT* = enum
    HV_OK_TRUE = - 1, HV_OK = 0, HV_BAD_PARAMETER = 1, HV_INCOMPATIBLE_TYPE = 2


type
  VALUE* = object
    t*: uint32
    u*: uint32
    d*: uint64

  VTYPE* = enum
    T_UNDEFINED = 0, T_NULL = 1, T_BOOL, T_INT, T_FLOAT, T_STRING, T_DATE, ## # INT64 - contains a 64-bit value representing the number of 100-nanosecond intervals since January 1, 1601 (UTC), a.k.a. FILETIME on Windows
    T_CURRENCY,               ## # INT64 - 14.4 fixed number. E.g. dollars = int64 / 10000;
    T_LENGTH,                 ## # length units, value is int or float, units are VALUE_UNIT_TYPE
    T_ARRAY, T_MAP, T_FUNCTION, T_BYTES, ## # sequence of bytes - e.g. image data
    T_OBJECT,                 ## # scripting object proxy (TISCRIPT/SCITER)
    T_DOM_OBJECT              ## # DOM object (CSSS!), use get_object_data to get HELEMENT


type
  VALUE_UNIT_TYPE* = enum
    UT_EM = 1,                  ## #height of the element's font.
    UT_EX = 2,                  ## #height of letter 'x'
    UT_PR = 3,                  ## #%
    UT_SP = 4,                  ## #%% "springs", a.k.a. flex units
    reserved1 = 5, reserved2 = 6, UT_PX = 7, ## #pixels
    UT_IN = 8,                  ## #inches (1 inch = 2.54 centimeters).
    UT_CM = 9,                  ## #centimeters.
    UT_MM = 10,                 ## #millimeters.
    UT_PT = 11,                 ## #points (1 point = 1/72 inches).
    UT_PC = 12,                 ## #picas (1 pica = 12 points).
    UT_DIP = 13, reserved3 = 14, UT_COLOR = 15, ## # color in int
    UT_URL = 16                 ## # url in string


type
  VALUE_UNIT_TYPE_DATE* = enum
    DT_HAS_DATE = 0x00000001,   ## # date contains date portion
    DT_HAS_TIME = 0x00000002,   ## # date contains time portion HH:MM
    DT_HAS_SECONDS = 0x00000004, ## # date contains time and seconds HH:MM:SS
    DT_UTC = 0x00000010         ## # T_DATE is known to be UTC. Otherwise it is local date/time


## # Sciter or TIScript specific

type
  VALUE_UNIT_TYPE_OBJECT* = enum
    UT_OBJECT_ARRAY = 0,        ## # type T_OBJECT of type Array
    UT_OBJECT_OBJECT = 1,       ## # type T_OBJECT of type Object
    UT_OBJECT_CLASS = 2,        ## # type T_OBJECT of type Type (class or namespace)
    UT_OBJECT_NATIVE = 3,       ## # type T_OBJECT of native Type with data slot (LPVOID)
    UT_OBJECT_FUNCTION = 4,     ## # type T_OBJECT of type Function
    UT_OBJECT_ERROR = 5         ## # type T_OBJECT of type Error


## # Sciter or TIScript specific

type
  VALUE_UNIT_TYPE_STRING* = enum
    UT_STRING_STRING = 0,       ## # string
    UT_STRING_ERROR = 1,        ## # is an error string
    UT_STRING_SECURE = 2,       ## # secure string ("wiped" on destroy)
    UT_STRING_SYMBOL = 0x0000FFFF ## # symbol in tiscript sense


## # Native functor

type
  NATIVE_FUNCTOR_INVOKE* = proc (tag: pointer; argc: uint32; argv: ptr VALUE;
                              retval: ptr VALUE) {.cdecl.}

## # retval may contain error definition

type
  NATIVE_FUNCTOR_RELEASE* = proc (tag: pointer) {.cdecl.}

## #*Callback function used with #ValueEnumElements().
## #  return TRUE to continue enumeration
## #

type
  KeyValueCallback* = proc (param: pointer; pkey: ptr VALUE; pval: ptr VALUE): bool {.cdecl.}
  VALUE_STRING_CVT_TYPE* = enum
    CVT_SIMPLE,               ## #/< simple conversion of terminal values
    CVT_JSON_LITERAL,         ## #/< json literal parsing/emission
    CVT_JSON_MAP,             ## #/< json parsing/emission, it parses as if token '{' already recognized
    CVT_XJSON_LITERAL         ## #/< x-json parsing/emission, date is emitted as ISO8601 date literal, currency is emitted in the form DDDD$CCC
