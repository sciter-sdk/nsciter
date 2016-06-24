
######## for value operations ##########

proc isUndefined*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_UNDEFINED

proc isBool*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_BOOL

proc isInt*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_INT

proc isFloat*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_FLOAT

proc isString*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_STRING

proc isSymbol*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_STRING and v.u == UT_STRING_SYMBOL

proc isDate*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_DATE

proc isCurrency*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_CURRENCY

proc isMap*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_MAP

proc isArray*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_ARRAY

proc isByte*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_BYTES

proc isObject*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT

proc isObjectNative*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_NATIVE

proc isObjectArray*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_ARRAY

proc isObjectFunction*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_FUNCTION

proc isObjectObject*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_OBJECT

proc isObjectClass*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_CLASS

proc isObjectError*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_ERROR

proc isDomElement*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_DOM_OBJECT

proc isNull*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_NULL

proc isFunction*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_FUNCTION

proc isNativeFunctor*(v:ptr Value):bool =
    return v.ValueIsNativeFunctor()

proc nullValue*(): ptr Value =
    var v = cast[ptr Value](alloc(sizeof(Value))) 
    v.t = T_NULL
    return v

proc clone*(v:ptr Value):ptr Value =
    var dst = nullValue()
    dst.ValueCopy(v)
    return dst

proc newValue*():ptr Value =
    var v = cast[ptr Value](alloc(sizeof(Value))) 
    v.ValueInit()
    return v

proc newValue*(dat:string):ptr Value =
    var ws = newWideCString(dat)
    result = newValue()
    result.ValueStringDataSet(ws, uint32(ws.len()), uint32(0))
    
proc newValue*[V:int|int8|int16|int32|uint|uint8|uint16|uint32](dat:V):ptr Value =
    result = newValue()
    result.ValueIntDataSet(dat, T_INT, 0)

proc newValue*[V:float|float32|float64](dat:V):ptr Value =
    result = newValue()
    result.ValueFloatDataSet(float64(dat), T_INT, 0)

proc newValue*(dat:bool):ptr Value =
    result = newValue()
    if dat:
        result.ValueIntDataSet(1, T_INT, 0)
    else:
        result.ValueIntDataSet(0, T_INT, 0)

proc convertFromString*(v:ptr Value, s:string, how:VALUE_STRING_CVT_TYPE) =
    var ws = newWideCString(s)
    v.ValueFromString(ws, uint32(ws.len()), how)

proc convertToString*(v:ptr Value, how:VALUE_STRING_CVT_TYPE):uint32 =
    # converts value to T_STRING inplace
    v.ValueToString(how)

proc getString*(v:ptr Value):string =
    var ws: WideCString
    var n:uint32
    v.ValueStringData(addr ws, addr n)
    return $(ws)

proc `$`*(v: ptr Value):string =
    if v.isString():
        return v.getString()
    if v.isFunction() or v.isNativeFunctor():
        return "<functor>"
    var nv = v.clone()
    discard nv.convertToString(CVT_SIMPLE)
    return nv.getString()

proc `$`*(x: Value):string =
    var xv = x
    var v = addr xv
    return $v

proc getInt32*(v: ptr Value): int32 =
    discard ValueIntData(v, addr result)

proc getInt*(v: ptr Value): int =
    result = cast[int](getInt32(v))

proc getBool*(v: ptr Value): bool =
    var i = getInt(v)
    if i == 0:
        return false
    return true

proc getFloat*(v: ptr Value): float =
    var f:float64
    v.ValueFloatData(addr f)
    return float(f)

proc getBytes*(v: ptr Value): seq[byte] =
    var p:pointer
    var size:uint32
    v.ValueBinaryData(addr p, addr size)
    result = newSeq[byte](size)
    copyMem(result[0].addr, p, int(size)*sizeof(byte))

proc setBytes*(v: ptr Value, dat: var openArray[byte]) =
    var p = dat[0].addr
    var size = dat.len()*sizeof(byte)
    v.ValueBinaryDataSet(p, uint32(size), T_BYTES, 0)
    
# for array and object types

proc len*(v: ptr Value): int =
    var n:int32 = 0
    v.ValueElementsCount(addr n)
    return int(n)

proc enumerate*(v: ptr Value, cb:KeyValueCallback): uint32 =
    v.ValueEnumElements(cb, nil)

proc `[]`*[I: Ordinal](v: ptr Value; i: I): ptr Value =
    result = nullValue()
    v.ValueNthElementValue(i, result)

proc `[]=`*[I: Ordinal](v: ptr Value; i: I; y: ptr Value) =
    ValueNthElementValueSet(v, i, y)

proc `[]`*(v: ptr Value; name:string): ptr Value =
    var key = newValue(name)
    result = nullValue()
    v.ValueGetValueOfKey(key, result)

proc `[]=`*(v: ptr Value; name:string; y: ptr Value) =
    var key = newValue(name)
    ValueSetValueToKey(v, key, y)
