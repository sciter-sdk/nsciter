type
    EventHandler* = ref object of RootObj
        on_mouse *: proc(he:HELEMENT , target:HELEMENT , event_type:uint32, pt:Point, mouseButtons:uint32, keyboardStates:uint32 ) 
        on_key   *: proc(he:HELEMENT , target:HELEMENT , event_type:uint32, code:uint32, keyboardStates:uint32 ) 
        on_focus *: proc(he:HELEMENT , target:HELEMENT , event_type:uint32 ) 
        on_timer *: proc(he:HELEMENT , extTimerId:uint32 ) 
        on_draw  *: proc(he:HELEMENT , draw_type:uint32,  hgfx:HGFX, rc:ptr Rect ) 
        on_size  *: proc(he:HELEMENT) 
        on_method_call*: proc(he:HELEMENT , methodID:uint32, params:ptr METHOD_PARAMS )
        on_script_call*: proc(he:HELEMENT , name:cstring, argc:uint32, argv:ptr VALUE, retval:ptr VALUE) 
        # on_script_call*: proc(he:HELEMENT , pvm:ptr tiscript_VM, tag:tiscript_value, retval:ptr tiscript_value) 
        on_event*: proc(he:HELEMENT , target:HELEMENT ,  typ:BEHAVIOR_EVENTS, reason:uint32 )
        on_data_arrived*: proc(he:HELEMENT , initiator:HELEMENT, data:pointer, dataSize:uint32, dataType:uint32 ) 
        on_scroll*: proc(he:HELEMENT , target:HELEMENT , cmd:SCROLL_EVENTS, pos:int32, isVertical:bool)
