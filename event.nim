type
    EventHandler* {.pure.} = object
        handle_mouse*: proc(he:HELEMENT, params: ptr MOUSE_PARAMS ):bool {.cdecl.}        
        handle_key*: proc(he:HELEMENT, params: ptr KEY_PARAMS ):bool            
        handle_focus*: proc(he:HELEMENT, params: ptr FOCUS_PARAMS ):bool {.cdecl.}        
        handle_timer*: proc(he:HELEMENT, params: ptr TIMER_PARAMS ):bool {.cdecl.}                              
        handle_size*: proc(he:HELEMENT ):bool {.cdecl.}
        handle_scroll*: proc(he:HELEMENT, params: ptr SCROLL_PARAMS):bool {.cdecl.}
        handle_gesture*: proc(he:HELEMENT, params: ptr GESTURE_PARAMS):bool {.cdecl.}                     
        handle_draw*: proc(he:HELEMENT, params: ptr DRAW_PARAMS ):bool {.cdecl.}         
        handle_method_call*: proc(he:HELEMENT, params: ptr METHOD_PARAMS ):bool {.cdecl.}  
        handle_tiscript_call*: proc(he:HELEMENT, params: ptr TISCRIPT_METHOD_PARAMS ):bool {.cdecl.}   
        handle_event*: proc(he:HELEMENT, params: ptr BEHAVIOR_EVENT_PARAMS ):bool {.cdecl.} 
        handle_data_arrived*: proc(he:HELEMENT, params: ptr DATA_ARRIVED_PARAMS ):bool {.cdecl.}
        handle_scripting_call*: proc(he:HELEMENT, params: ptr SCRIPTING_METHOD_PARAMS):bool {.cdecl.}

        detached*: proc(he:HELEMENT) {.cdecl.}
        attached*: proc(he:HELEMENT) {.cdecl.}

proc element_proc(tag: pointer; he: HELEMENT; evtg: uint32; prms: pointer): bool {.cdecl.} =
    var pThis:ptr EventHandler = cast[ptr EventHandler](tag)
    if pThis == nil:
        return false
    case EVENT_GROUPS(evtg)
    # of SUBSCRIPTIONS_REQUEST:
    #   var p: ptr UINT = cast[ptr UINT](prms)
    #   return pThis.subscription(he, p)
    of HANDLE_INITIALIZATION:
      var p: ptr INITIALIZATION_PARAMS = cast[ptr INITIALIZATION_PARAMS](prms)
      if p.cmd == BEHAVIOR_DETACH: pThis.detached(he)
      elif p.cmd == BEHAVIOR_ATTACH: pThis.attached(he)
      return true
    of HANDLE_MOUSE:
      var p: ptr MOUSE_PARAMS = cast[ptr MOUSE_PARAMS](prms)
      return pThis.handle_mouse(he, p)
    of HANDLE_KEY:
      var p: ptr KEY_PARAMS = cast[ptr KEY_PARAMS](prms)
      return pThis.handle_key(he, p)
    of HANDLE_FOCUS:
      var p: ptr FOCUS_PARAMS = cast[ptr FOCUS_PARAMS](prms)
      return pThis.handle_focus(he, p)
    of HANDLE_DRAW:
      var p: ptr DRAW_PARAMS = cast[ptr DRAW_PARAMS](prms)
      return pThis.handle_draw(he, p)
    of HANDLE_TIMER:
      var p: ptr TIMER_PARAMS = cast[ptr TIMER_PARAMS](prms)
      return pThis.handle_timer(he, p)
    of HANDLE_BEHAVIOR_EVENT:
      var p: ptr BEHAVIOR_EVENT_PARAMS = cast[ptr BEHAVIOR_EVENT_PARAMS](prms)
      return pThis.handle_event(he, p)
    of HANDLE_METHOD_CALL:
      var p: ptr METHOD_PARAMS = cast[ptr METHOD_PARAMS](prms)
      return pThis.handle_method_call(he, p)
    of HANDLE_DATA_ARRIVED:
      var p: ptr DATA_ARRIVED_PARAMS = cast[ptr DATA_ARRIVED_PARAMS](prms)
      return pThis.handle_data_arrived(he, p)
    of HANDLE_SCROLL:
      var p: ptr SCROLL_PARAMS = cast[ptr SCROLL_PARAMS](prms)
      return pThis.handle_scroll(he, p)
    of HANDLE_SIZE:
      discard pThis.handle_size(he)
      return false
      ## # call using sciter::value's (from CSSS!)
    of HANDLE_SCRIPTING_METHOD_CALL:
      var p: ptr SCRIPTING_METHOD_PARAMS = cast[ptr SCRIPTING_METHOD_PARAMS](prms)
      return pThis.handle_scripting_call(he, p)
      ## # call using tiscript::value's (from the script)
    of HANDLE_TISCRIPT_METHOD_CALL:
      var p: ptr TISCRIPT_METHOD_PARAMS = cast[ptr TISCRIPT_METHOD_PARAMS](prms)
      return pThis.handle_tiscript_call(he, p)
    of HANDLE_GESTURE:
      var p: ptr GESTURE_PARAMS = cast[ptr GESTURE_PARAMS](prms)
      return pThis.handle_gesture(he, p)
    else:
      return false
    return false

proc AttachEventHandler*(hwnd: HWINDOW; h: ptr EventHandler): int32 =
    SciterWindowAttachEventHandler(hwnd, element_proc, h, HANDLE_ALL)
