import sciter, os, strutils
        
SciterSetOption(nil, uint32(SCITER_SET_DEBUG_MODE), 1)
# echo repr SAPI()
echo SciterClassName()
var s = SAPI()
echo "spi:", repr s
echo "s.version:", s.version
echo "s.SciterClassName:", s.SciterClassName()
echo "s.SciterVersion:", toHex(int(s.SciterVersion(false)), 5)
echo "s.SciterVersion:", toHex(int(s.SciterVersion(true)), 5)
# echo SciterVersion(false)
echo "SciterCreateWindow:", repr SciterCreateWindow
echo "s.SciterCreateWindow:", repr s.SciterCreateWindow
var r = cast[ptr Rect](alloc0(sizeof(Rect)))
r.top = 200
r.left = 500
r.bottom = 500
r.right = 800
var wnd = SciterCreateWindow((SW_CONTROLS or SW_MAIN or SW_TITLEBAR), r, nil, nil, nil)
# var wnd = SciterCreateWindow(0, nil, nil, nil, nil)
if wnd == nil:
    quit("wnd is nil")
var html = "hello世界"
echo "wnd:", repr wnd
wnd.setTitle("test")
wnd.SciterLoadFile("./test.html")
wnd.onClick(proc()=echo "generic click")
wnd.onClick(proc()=echo "generic click 2")
var testFn = proc() =
    var i:int8 = 100
    var p = newValue(i)
    echo p, p.getInt()
    var s = "a test string"
    var sv = newValue(s)
    var s2 = sv.getString()
    echo s, "->", s2
    echo s.len, s2.len
    echo "value:", p, "\t", sv
    var f = 6.341
    var fv = newValue(f)
    echo "float value:", f, "\t", fv, "\t", fv.getFloat()
    var b:seq[byte] = @[byte(1),byte(2),byte(3),byte(4)]
    echo b
    var bv = nullValue()
    bv.setBytes(b)
    echo "bv:", bv.getBytes()
    var o = nullValue()
    o["key"] = newValue(i)
    echo "o:", o
testFn()
var testVptr = proc()=
    var i:int16 = 100
    var v = newValue(i)
    echo v, "\tv.isNativeFunctor():", v.isNativeFunctor()
    var vvv = Value()
    echo vvv, "\tvvv.isNativeFunctor():", vvv.isNativeFunctor()
testVptr()
echo "dfm hello ret: ", wnd.defineScriptingFunction("hello", proc(args: seq[ptr Value]):ptr Value =
    echo "hello from script method"
    echo "args:", args
)

proc testCallback() =
    echo "dfm cbCall ret: ", wnd.defineScriptingFunction("cbCall", proc(args:seq[ptr Value]):ptr Value=
        echo "cbCall args:", args
        var fn = args[0]
        var ret = fn.invoke(newValue(100), newValue("arg2"))
        echo "cb ret:", ret
        ret = fn.invokeWithSelf(newValue("string as this"), newValue(100), newValue("arg2"))
    )
testCallback()

proc nf(args: seq[ptr Value]):ptr Value=
    return newValue("nf ok")

proc testNativeFunctor() =
    wnd.defineScriptingFunction("api", proc(args:seq[ptr Value]):ptr Value =
        result = newValue()
        result["i"] = newValue(1000)
        result["str"] = newValue("a string")
        var fn = newValue()
        # fn.setNativeFunctor(nf)
        result["fn"] = fn
    )
testNativeFunctor()
echo HANDLE_SCRIPTING_METHOD_CALL, "->", ord(HANDLE_SCRIPTING_METHOD_CALL) 
wnd.run