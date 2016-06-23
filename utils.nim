
######## for value operations ##########

proc vptr[VT](v:VT): ptr Value =
    when v is Value:
        return addr v
    when v is ptr Value:
        return v

proc isUndefined*[VT](v:VT):bool =
    return v.t == T_UNDEFINED

proc isBool*[VT](v:VT):bool =
    return v.t == T_BOOL

proc isInt*[VT](v:VT):bool =
    return v.t == T_INT

proc isFloat*[VT](v:VT):bool =
    return v.t == T_FLOAT

proc isString*[VT](v:VT):bool =
    return v.t == T_STRING

proc isSymbol*[VT](v:VT):bool =
    return v.t == T_STRING and v.u == UT_STRING_SYMBOL

proc isDate*[VT](v:VT):bool =
    return v.t == T_DATE

proc isCurrency*[VT](v:VT):bool =
    return v.t == T_CURRENCY

proc isMap*[VT](v:VT):bool =
    return v.t == T_MAP

proc isArray*[VT](v:VT):bool =
    return v.t == T_ARRAY

proc isFunction*[VT](v:VT):bool =
    return v.t == T_FUNCTION

proc isNativeFunctor*[VT](v:VT):bool =
    var p = vptr(v)
    return p.ValueIsNativeFunctor()

proc isByte*[VT](v:VT):bool =
    return v.t == T_BYTES

proc isObject*[VT](v:VT):bool =
    return v.t == T_OBJECT

proc isObjectNative*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_NATIVE

proc isObjectArray*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_ARRAY

proc isObjectFunction*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_FUNCTION

proc isObjectObject*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_OBJECT

proc isObjectClass*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_CLASS

proc isObjectError*[VT](v:VT):bool =
    return v.t == T_OBJECT and v.u == UT_OBJECT_ERROR

proc isDomElement*[VT](v:VT):bool =
    return v.t == T_DOM_OBJECT

proc isNull*[VT](v:VT):bool =
    return v.t == T_NULL

proc nullValue*(): ptr Value =
    var v = cast[ptr Value](alloc(sizeof(Value))) 
    v.t = T_NULL
    discard v.ValueInit()
    return v

proc clone*[VT](v:VT):ptr Value =
    var src = vptr(v)
    var dst = nullValue()
    dst.ValueCopy(src)
    return dst

import typeinfo

proc toInt32(x: Any):int32 =
    return cast[int32](x.getBiggestInt())

proc newValue*[T](x:var T): ptr Value =
    result = cast[ptr Value](alloc(sizeof(Value)))
    result.ValueInit()
    var a = toAny(x)
    var typekind = kind(a)
    case typekind
    of akInt, akInt8, akInt16, akInt32:
        result.ValueIntDataSet(toInt32(a), T_INT, 0)
    of akInt64: # for date and currency
        result = nullValue()
    of akString:
        var ws = newWideCString(a.getString())
        result.ValueStringDataSet(ws, uint32(ws.len()), uint32(0))
    else:
        result = nullValue()

proc convertFromString*(v: ptr Value, s:string, how:VALUE_STRING_CVT_TYPE) =
    var ws = newWideCString(s)
    v.ValueFromString(ws, uint32(ws.len()), how)

proc convertToString*(v: ptr Value, how:VALUE_STRING_CVT_TYPE):uint32 =
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

proc getInt32*[VT](v:VT): int32 =
    discard ValueIntData(vptr(v), addr result)

proc getInt*[VT](v:VT): int =
    result = cast[int](getInt32(v))
