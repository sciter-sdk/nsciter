
######## for value operations ##########

proc vptr[VT: Value | ptr Value](v:VT): ptr Value =
    when v is Value:
        return addr v
    when v is ptr Value:
        return v

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

proc isFunction*[VT: Value | ptr Value](v:VT):bool =
    return v.t == T_FUNCTION

proc isNativeFunctor*[VT: Value | ptr Value](v:VT):bool =
    var p = vptr(v)
    return p.ValueIsNativeFunctor()

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

proc nullValue*(): ptr Value =
    var v = cast[ptr Value](alloc(sizeof(Value))) 
    v.t = T_NULL
    discard v.ValueInit()
    return v

proc clone*[VT: Value | ptr Value](v:VT):ptr Value =
    var src = vptr(v)
    var dst = nullValue()
    dst.ValueCopy(src)
    return dst

proc newValue*():ptr Value =
    result = nullValue()

proc newValue*(dat:string):ptr Value =
    var ws = newWideCString(dat)
    result = nullValue()
    result.ValueStringDataSet(ws, uint32(ws.len()), uint32(0))
    
proc newValue*[V:int|int8|int16|int32|uint|uint8|uint16|uint32](dat:V):ptr Value =
    result = nullValue()
    result.ValueIntDataSet(dat, T_INT, 0)

proc newValue*[V:float|float32|float64](dat:V):ptr Value =
    result = nullValue()
    result.ValueFloatDataSet(float64(dat), T_INT, 0)

proc newValue*(dat:bool):ptr Value =
    result = nullValue()
    if dat:
        result.ValueIntDataSet(1, T_INT, 0)
    else:
        result.ValueIntDataSet(0, T_INT, 0)

proc convertFromString*[VT: Value | ptr Value](x:VT, s:string, how:VALUE_STRING_CVT_TYPE) =
    var v = vptr(x)
    var ws = newWideCString(s)
    v.ValueFromString(ws, uint32(ws.len()), how)

proc convertToString*[VT: Value | ptr Value](x:VT, how:VALUE_STRING_CVT_TYPE):uint32 =
    # converts value to T_STRING inplace
    var v = vptr(x)
    v.ValueToString(how)

proc getString*[VT: Value | ptr Value](x:VT):string =
    var v = vptr(x)
    var ws: WideCString
    var n:uint32
    v.ValueStringData(addr ws, addr n)
    return $(ws)

proc `$`*[VT: Value | ptr Value](x: VT):string =
    var v = vptr(x)
    if v.isString():
        return v.getString()
    if v.isFunction() or v.isNativeFunctor():
        return "<functor>"
    var nv = v.clone()
    discard nv.convertToString(CVT_SIMPLE)
    return nv.getString()

proc getInt32*[VT: Value | ptr Value](v:VT): int32 =
    discard ValueIntData(vptr(v), addr result)

proc getInt*[VT: Value | ptr Value](x:VT): int =
    result = cast[int](getInt32(x))

proc getBool*[VT: Value | ptr Value](x:VT): float =
    var i = getInt(x)
    if i == 0:
        return false
    return true

proc getFloat*[VT: Value | ptr Value](x:VT): float =
    var v = vptr(x)
    var f:float64
    v.ValueFloatData(addr f)
    return float(f)

proc getBytes*[VT: Value | ptr Value](x:VT): seq[byte] =
    var v = vptr(x)
    var p:pointer
    var size:uint32
    v.ValueBinaryData(addr p, addr size)
    result = newSeq[byte](size)
    copyMem(result[0].addr, p, int(size)*sizeof(byte))

proc setBytes*[VT: Value | ptr Value](x:VT, dat: var openArray[byte]) =
    var v = vptr(x)
    var p = dat[0].addr
    var size = dat.len()*sizeof(byte)
    v.ValueBinaryDataSet(p, uint32(size), T_BYTES, 0)
    
# for array and object types

proc len*[VT: Value | ptr Value](x:VT): int =
    var v = vptr(x)
    var n:int32 = 0
    v.ValueElementsCount(addr n)
    return int(n)

proc enumerate*[VT: Value | ptr Value](x:VT, cb:KeyValueCallback): uint32 =
    var v = vptr(x)
    v.ValueEnumElements(cb, nil)

proc `[]`*[I: Ordinal, VT: Value | ptr Value](x: VT; i: I): ptr Value =
    var v = vptr(x)
    result = nullValue()
    v.ValueNthElementValue(i, result)

proc `[]=`*[I: Ordinal, VT: Value | ptr Value](x: VT; i: I; y: VT) =
    ValueNthElementValueSet(vptr(x), i, vptr(y))

proc `[]`*[VT: Value | ptr Value](x: VT; name:string): ptr Value =
    var v = vptr(x)
    var key = newValue(name)
    result = nullValue()
    v.ValueGetValueOfKey(key, result)

proc `[]=`*[VT: Value | ptr Value](x: VT; name:string; y: VT) =
    var key = newValue(name)
    ValueSetValueToKey(vptr(x), key, vptr(y))
