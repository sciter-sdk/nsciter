type
    EventHandlerObj* = object
        handle_mouse*: proc(he:HELEMENT, params: ptr MOUSE_PARAMS ):bool
        handle_key*: proc(he:HELEMENT, params: ptr KEY_PARAMS ):bool
        handle_focus*: proc(he:HELEMENT, params: ptr FOCUS_PARAMS ):bool
        handle_timer*: proc(he:HELEMENT, params: ptr TIMER_PARAMS ):bool
        handle_size*: proc(he:HELEMENT ):bool
        handle_scroll*: proc(he:HELEMENT, params: ptr SCROLL_PARAMS):bool
        handle_gesture*: proc(he:HELEMENT, params: ptr GESTURE_PARAMS):bool
        handle_draw*: proc(he:HELEMENT, params: ptr DRAW_PARAMS ):bool
        handle_method_call*: proc(he:HELEMENT, params: ptr METHOD_PARAMS ):bool
        handle_tiscript_call*: proc(he:HELEMENT, params: ptr TISCRIPT_METHOD_PARAMS ):bool
        handle_event*: proc(he:HELEMENT, params: ptr BEHAVIOR_EVENT_PARAMS ):bool
        handle_data_arrived*: proc(he:HELEMENT, params: ptr DATA_ARRIVED_PARAMS ):bool
        handle_scripting_call*: proc(he:HELEMENT, params: ptr SCRIPTING_METHOD_PARAMS):bool

        detached*: proc(he:HELEMENT)
        attached*: proc(he:HELEMENT)

    EventHandler* = ptr EventHandlerObj
    EventTarget = HWINDOW or HELEMENT

var fn_handle_mouse = proc(he:HELEMENT, params: ptr MOUSE_PARAMS ):bool = return false
var fn_handle_key = proc(he:HELEMENT, params: ptr KEY_PARAMS ):bool = return false
var fn_handle_focus = proc(he:HELEMENT, params: ptr FOCUS_PARAMS ):bool = return false
var fn_handle_timer = proc(he:HELEMENT, params: ptr TIMER_PARAMS ):bool = return false
var fn_handle_size = proc(he:HELEMENT ):bool = return false
var fn_handle_scroll = proc(he:HELEMENT, params: ptr SCROLL_PARAMS):bool = return false
var fn_handle_gesture = proc(he:HELEMENT, params: ptr GESTURE_PARAMS):bool = return false
var fn_handle_draw = proc(he:HELEMENT, params: ptr DRAW_PARAMS ):bool = return false
var fn_handle_method_call = proc(he:HELEMENT, params: ptr METHOD_PARAMS ):bool = return false
var fn_handle_tiscript_call = proc(he:HELEMENT, params: ptr TISCRIPT_METHOD_PARAMS ):bool = return false
var fn_handle_event = proc(he:HELEMENT, params: ptr BEHAVIOR_EVENT_PARAMS ):bool = return false
var fn_handle_data_arrived = proc(he:HELEMENT, params: ptr DATA_ARRIVED_PARAMS ):bool = return false
var fn_handle_scripting_call = proc(he:HELEMENT, params: ptr SCRIPTING_METHOD_PARAMS):bool = return false
var fn_ttach = proc(he:HELEMENT) = discard

proc newEventHandler*(): EventHandler =
    var eh:EventHandler = cast[EventHandler](alloc(sizeof(EventHandlerObj)))
    eh.handle_mouse = fn_handle_mouse
    eh.handle_key = fn_handle_key
    eh.handle_focus = fn_handle_focus
    eh.handle_timer = fn_handle_timer
    eh.handle_size = fn_handle_size
    eh.handle_scroll = fn_handle_scroll
    eh.handle_gesture = fn_handle_gesture
    eh.handle_draw = fn_handle_draw
    eh.handle_method_call =  fn_handle_method_call
    eh.handle_tiscript_call = fn_handle_tiscript_call
    eh.handle_event = fn_handle_event
    eh.handle_data_arrived = fn_handle_data_arrived
    eh.handle_scripting_call = fn_handle_scripting_call
    eh.detached = fn_ttach
    eh.attached = fn_ttach
    return eh

import tables
var evct = newCountTable[EventHandler]()

proc element_proc(tag: pointer; he: HELEMENT; evtg: uint32; prms: pointer): bool {.stdcall.} =
    var pThis:EventHandler = cast[EventHandler](tag)
    if pThis == nil:
        return false
    case evtg
    # of SUBSCRIPTIONS_REQUEST:
    #   var p: ptr UINT = cast[ptr UINT](prms)
    #   return pThis.subscription(he, p)
    of uint32(HANDLE_INITIALIZATION):
    var p: ptr INITIALIZATION_PARAMS = cast[ptr INITIALIZATION_PARAMS](prms)
    if p.cmd == BEHAVIOR_DETACH:
        pThis.detached(he)
        evct.inc(pThis, -1)
        if evct.contains(pThis):
        dealloc(pThis)
    elif p.cmd == BEHAVIOR_ATTACH:
        pThis.attached(he)
        evct.inc(pThis)
    return true
    of uint32(HANDLE_MOUSE):
    var p: ptr MOUSE_PARAMS = cast[ptr MOUSE_PARAMS](prms)
    return pThis.handle_mouse(he, p)
    of uint32(HANDLE_KEY):
    var p: ptr KEY_PARAMS = cast[ptr KEY_PARAMS](prms)
    return pThis.handle_key(he, p)
    of uint32(HANDLE_FOCUS):
    var p: ptr FOCUS_PARAMS = cast[ptr FOCUS_PARAMS](prms)
    return pThis.handle_focus(he, p)
    of uint32(HANDLE_DRAW):
    var p: ptr DRAW_PARAMS = cast[ptr DRAW_PARAMS](prms)
    return pThis.handle_draw(he, p)
    of uint32(HANDLE_TIMER):
    var p: ptr TIMER_PARAMS = cast[ptr TIMER_PARAMS](prms)
    return pThis.handle_timer(he, p)
    of uint32(HANDLE_BEHAVIOR_EVENT):
    var p: ptr BEHAVIOR_EVENT_PARAMS = cast[ptr BEHAVIOR_EVENT_PARAMS](prms)
    return pThis.handle_event(he, p)
    of uint32(HANDLE_METHOD_CALL):
    var p: ptr METHOD_PARAMS = cast[ptr METHOD_PARAMS](prms)
    return pThis.handle_method_call(he, p)
    of uint32(HANDLE_DATA_ARRIVED):
    var p: ptr DATA_ARRIVED_PARAMS = cast[ptr DATA_ARRIVED_PARAMS](prms)
    return pThis.handle_data_arrived(he, p)
    of uint32(HANDLE_SCROLL):
    var p: ptr SCROLL_PARAMS = cast[ptr SCROLL_PARAMS](prms)
    return pThis.handle_scroll(he, p)
    of uint32(HANDLE_SIZE):
    discard pThis.handle_size(he)
    return false
    ## # call using sciter::value's (from CSSS!)
    of uint32(HANDLE_SCRIPTING_METHOD_CALL):
    var p: ptr SCRIPTING_METHOD_PARAMS = cast[ptr SCRIPTING_METHOD_PARAMS](prms)
    return pThis.handle_scripting_call(he, p)
    ## # call using tiscript::value's (from the script)
    of uint32(HANDLE_TISCRIPT_METHOD_CALL):
    var p: ptr TISCRIPT_METHOD_PARAMS = cast[ptr TISCRIPT_METHOD_PARAMS](prms)
    return pThis.handle_tiscript_call(he, p)
    of uint32(HANDLE_GESTURE):
    var p: ptr GESTURE_PARAMS = cast[ptr GESTURE_PARAMS](prms)
    return pThis.handle_gesture(he, p)
    else:
    return false
    return false

proc Attach*(target:EventTarget, eh:EventHandler, mask:uint32 = HANDLE_ALL): int32 {.discardable.} =
    when EventTarget is HWINDOW:
        result = SciterWindowAttachEventHandler(target, element_proc, eh, mask)
    when EventTarget is HELEMENT:
        result = SciterAttachEventHandler(target, element_proc, eh)

proc Detach*(target:EventTarget, eh:EventHandler , mask:uint32 = HANDLE_ALL): int32 {.discardable.} =
    when EventTarget is HWINDOW:
        result = SciterWindowDetachEventHandler(target, element_proc, eh, mask)
    when EventTarget is HELEMENT:
        result = SciterDetachEventHandler(target, element_proc, eh)

proc onClick*(target:EventTarget, handler:proc()): int32 {.discardable.} =
    var eh = newEventHandler()
    eh.handle_event = proc(he:HELEMENT, params: ptr BEHAVIOR_EVENT_PARAMS ):bool =
        if params.cmd == BUTTON_CLICK:
            handler()
        return false
    result = target.Attach(eh, HANDLE_BEHAVIOR_EVENT)

type
  NativeFunctor* = proc(args: seq[Value]):Value

proc defineScriptingFunction*(target:EventTarget, name:string, fn:NativeFunctor): int32 {.discardable.} =
    var eh = newEventHandler()
    eh.handle_scripting_call = proc(he:HELEMENT, params: ptr SCRIPTING_METHOD_PARAMS):bool =
        if params.name != name:
            return false
        var args = newSeq[Value](params.argc)
        var base = cast[uint](params.argv)
        var step = cast[uint](sizeof(Value))
        if params.argc > 0.uint32:
            for idx in 0..params.argc-1:
                var p = cast[ptr Value](base + step*uint(idx))
                args[int(idx)] = p[]
        params.result = fn(args)
        return true
    result = target.Attach(eh, HANDLE_SCRIPTING_METHOD_CALL)
