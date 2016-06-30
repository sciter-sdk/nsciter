
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

template xDefPtr(x, v:untyped) {.immediate.} =
    var v:ptr Value = nil
    when x is Value:
        var nx = x
        v = addr nx
    else:
        v = x

proc isNativeFunctor*[VT:Value|ptr Value](x:VT):bool =
    xDefPtr(x, v)
    return v.ValueIsNativeFunctor()

proc nullValue*(): ptr Value =
    var v = cast[ptr Value](alloc(sizeof(Value))) 
    v.t = T_NULL
    return v

proc clone*[VT:Value|ptr Value](x:VT):ptr Value =
    xDefPtr(x, v)
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

proc newValue*(dat:int32):ptr Value=
    result = newValue()
    result.ValueIntDataSet(dat, T_INT, 0)

proc newValue*(dat:float64):ptr Value =
    result = newValue()
    result.ValueFloatDataSet(dat, T_FLOAT, 0)

proc newValue*(dat:bool):ptr Value =
    result = newValue()
    if dat:
        result.ValueIntDataSet(1, T_INT, 0)
    else:
        result.ValueIntDataSet(0, T_INT, 0)

proc convertFromString*[VT:Value|ptr Value](x:VT, s:string, how:VALUE_STRING_CVT_TYPE) =
    xDefPtr(x, v)
    var ws = newWideCString(s)
    v.ValueFromString(ws, uint32(ws.len()), how)

proc convertToString*[VT:Value|ptr Value](x:VT, how:VALUE_STRING_CVT_TYPE):uint32 =
    # converts value to T_STRING inplace
    xDefPtr(x, v)
    v.ValueToString(how)

proc getString*[VT:Value|ptr Value](x:VT):string =
    xDefPtr(x, v)
    var ws: WideCString
    var n:uint32
    v.ValueStringData(addr ws, addr n)
    return $(ws)

proc `$`*(v: ptr Value):string =
    if v.isString():
        return v.getString()
    if v.isFunction() or v.isNativeFunctor() or v.isObjectFunction():
        return "<functor>"
    var nv = v.clone()
    discard nv.convertToString(CVT_SIMPLE)
    return nv.getString()

proc `$`*(x: Value):string =
    var xv = x
    var v = addr xv
    return $v

proc getInt32*[VT:Value|ptr Value](x:VT): int32 =
    xDefPtr(x, v)
    discard ValueIntData(v, addr result)

proc getInt*[VT:Value|ptr Value](x:VT): int =
    xDefPtr(x, v)
    result = cast[int](getInt32(v))

proc getBool*[VT:Value|ptr Value](x:VT): bool =
    xDefPtr(x, v)
    var i = getInt(v)
    if i == 0:
        return false
    return true

proc getFloat*[VT:Value|ptr Value](x:VT): float =
    xDefPtr(x, v)
    var f:float64
    v.ValueFloatData(addr f)
    return float(f)

proc getBytes*[VT:Value|ptr Value](x:VT): seq[byte] =
    xDefPtr(x, v)
    var p:pointer
    var size:uint32
    v.ValueBinaryData(addr p, addr size)
    result = newSeq[byte](size)
    copyMem(result[0].addr, p, int(size)*sizeof(byte))

proc setBytes*[VT:Value|ptr Value](x:VT, dat: var openArray[byte]) =
    xDefPtr(x, v)
    var p = dat[0].addr
    var size = dat.len()*sizeof(byte)
    v.ValueBinaryDataSet(p, uint32(size), T_BYTES, 0)
    
# for array and object types

proc len*[VT:Value|ptr Value](x:VT): int =
    xDefPtr(x, v)
    var n:int32 = 0
    v.ValueElementsCount(addr n)
    return int(n)

proc enumerate*[VT:Value|ptr Value](x:VT, cb:KeyValueCallback): uint32 =
    xDefPtr(x, v)
    v.ValueEnumElements(cb, nil)

proc `[]`*[I: Ordinal, VT:Value|ptr Value](x:VT; i: I): ptr Value =
    xDefPtr(x, v)
    result = nullValue()
    v.ValueNthElementValue(i, result)

proc `[]=`*[I: Ordinal, VT:Value|ptr Value](x:VT; i: I; y: VT) =
    xDefPtr(x, v)
    xDefPtr(y, yp)
    ValueNthElementValueSet(v, i, yp)

proc `[]`*[VT:Value|ptr Value](x:VT; name:string): ptr Value =
    xDefPtr(x, v)
    var key = newValue(name)
    result = nullValue()
    v.ValueGetValueOfKey(key, result)

proc `[]=`*[VT:Value|ptr Value](x:VT; name:string; y: VT) =
    xDefPtr(x, v)
    xDefPtr(y, yp)
    var key = newValue(name)
    ValueSetValueToKey(v, key, yp)

## value functions calls

proc invokeWithSelf*[VT:Value|ptr Value](x:VT, self:VT, args:varargs[ptr Value]):Value =
    xDefPtr(x, v)
    xDefPtr(self, selfp)
    result = Value()
    var clen = len(args)
    var cargs = newSeq[Value](clen)
    for i in 0..clen-1:
        cargs[i] = args[i][]
    v.ValueInvoke(selfp, uint32(len(args)), cargs[0].addr, result.addr, nil)
    
proc invoke*[VT:Value|ptr Value](x:VT, args:varargs[ptr Value]):Value =
    var self = newValue()
    invokeWithSelf(x, self, args)

var nfs = newSeq[NativeFunctor]()

proc pinvoke(tag: int; 
             argc: uint32; 
             argv: ptr VALUE;
             retval: ptr VALUE) {.cdecl.} =
    var nf = nfs[tag]
    var args = newSeq[ptr Value](1)
    retval.ValueInit()
    var r = nf(args)
    retval.ValueCopy(r)

proc prelease(tag: int) {.cdecl.} =
    discard

proc setNativeFunctor*(v:ptr Value, nf:NativeFunctor) =
    nfs.add(nf)
    v.ValueNativeFunctorSet(pinvoke, prelease, nfs.len()-1)

