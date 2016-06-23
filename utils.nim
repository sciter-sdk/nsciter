
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

proc getInt*[VT: Value | ptr Value](v:VT): int =
    result = cast[int](getInt32(v))
