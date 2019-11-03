## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## #
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## #
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## #
## #
## #  Behaviors support (a.k.a windowless controls)
## #

## #!\file
## #\brief Behaiviors support (a.k.a windowless scriptable controls)
## #

## #* event groups.
## #

type
  EVENT_GROUPS* {.size: sizeof(cint).} = enum
    HANDLE_INITIALIZATION = 0x00000000, ## #* attached/detached
    HANDLE_MOUSE = 0x00000001,  ## #* mouse events
    HANDLE_KEY = 0x00000002,    ## #* key events
    HANDLE_FOCUS = 0x00000004,  ## #* focus events, if this flag is set it also means that element it attached to is focusable
    HANDLE_SCROLL = 0x00000008, ## #* scroll events
    HANDLE_TIMER = 0x00000010,  ## #* timer event
    HANDLE_SIZE = 0x00000020,   ## #* size changed event
    HANDLE_DRAW = 0x00000040,   ## #* drawing request (event)
    HANDLE_DATA_ARRIVED = 0x00000080, ## #* requested data () has been delivered
    HANDLE_BEHAVIOR_EVENT = 0x00000100, ## #* logical, synthetic events:
                                    ## #                                                 BUTTON_CLICK, HYPERLINK_CLICK, etc.,
                                    ## #                                                 a.k.a. notifications from intrinsic behaviors
    HANDLE_METHOD_CALL = 0x00000200, ## #* behavior specific methods
    HANDLE_SCRIPTING_METHOD_CALL = 0x00000400, ## #* behavior specific methods
    HANDLE_TISCRIPT_METHOD_CALL = 0x00000800, ## #* behavior specific methods using direct tiscript::value's
    HANDLE_EXCHANGE = 0x00001000, ## #* system drag-n-drop
    HANDLE_GESTURE = 0x00002000, ## #* touch input events
    HANDLE_ALL = 0x0000FFFF,    ## # all of them
    SUBSCRIPTIONS_REQUEST = 0xFFFFFFFF ## #* special value for getting subscription flags


## #*Element callback function for all types of events. Similar to WndProc
## #  \param tag \b LPVOID, tag assigned by SciterAttachEventHandler function (like GWL_USERDATA)
## #  \param he \b HELEMENT, this element handle (like HWINDOW)
## #  \param evtg \b UINT, group identifier of the event, value is one of EVENT_GROUPS
## #  \param prms \b LPVOID, pointer to group specific parameters structure.
## #  \return true if event was handled, false otherwise.
## #

## # signature of the function exported from external behavior/dll.

type
  SciterBehaviorFactory* = proc (a2: cstring; a3: HELEMENT; a4: ptr LPElementEventProc;
                              a5: ptr pointer): bool {.cdecl.}
  PHASE_MASK* = enum
    BUBBLING = 0,               ## # bubbling (emersion) phase
    SINKING = 0x00008000,       ## # capture (immersion) phase, this flag is or'ed with EVENTS codes below
    HANDLED = 0x00010000


type
  MOUSE_BUTTONS* = enum
    MAIN_MOUSE_BUTTON = 1,      ## #aka left button
    PROP_MOUSE_BUTTON = 2,      ## #aka right button
    MIDDLE_MOUSE_BUTTON = 4


type
  KEYBOARD_STATES* = enum
    CONTROL_KEY_PRESSED = 0x00000001, SHIFT_KEY_PRESSED = 0x00000002,
    ALT_KEY_PRESSED = 0x00000004


## # parameters of evtg == HANDLE_INITIALIZATION

type
  INITIALIZATION_EVENTS* = enum
    BEHAVIOR_DETACH = 0, BEHAVIOR_ATTACH = 1


type
  INITIALIZATION_PARAMS* = object
    cmd*: uint32               ## # INITIALIZATION_EVENTS

  DRAGGING_TYPE* = enum
    NO_DRAGGING, DRAGGING_MOVE, DRAGGING_COPY


## # parameters of evtg == HANDLE_MOUSE

type
  MOUSE_EVENTS* = enum
    MOUSE_ENTER = 0, MOUSE_LEAVE, MOUSE_MOVE, MOUSE_UP, MOUSE_DOWN, MOUSE_DCLICK,
    MOUSE_WHEEL, MOUSE_TICK,   ## # mouse pressed ticks
    MOUSE_IDLE,               ## # mouse stay idle for some time
    DROP = 9,                   ## # item dropped, target is that dropped item
    DRAG_ENTER = 0x0000000A,    ## # drag arrived to the target element that is one of current drop targets.
    DRAG_LEAVE = 0x0000000B,    ## # drag left one of current drop targets. target is the drop target element.
    DRAG_REQUEST = 0x0000000C,  ## # drag src notification before drag start. To cancel - return true from handler.
    MOUSE_CLICK = 0x000000FF,   ## # mouse click event
    DRAGGING = 0x00000100 ## # This flag is 'ORed' with MOUSE_ENTER..MOUSE_DOWN codes if dragging operation is in effect.
                      ## # E.g. event DRAGGING | MOUSE_MOVE is sent to underlying DOM elements while dragging.


type
  MOUSE_PARAMS* = object
    cmd*: uint32               ## # MOUSE_EVENTS
    target*: HELEMENT          ## # target element
    pos*: Point                ## # position of cursor, element relative
    pos_view*: Point           ## # position of cursor, view relative
    button_state*: uint32      ## # MOUSE_BUTTONS
    alt_state*: uint32         ## # KEYBOARD_STATES
    cursor_type*: uint32       ## # CURSOR_TYPE to set, see CURSOR_TYPE
    is_on_icon*: bool          ## # mouse is over icon (foreground-image, foreground-repeat:no-repeat)
    dragging*: HELEMENT        ## # element that is being dragged over, this field is not NULL if (cmd & DRAGGING) != 0
    dragging_mode*: uint32     ## # see DRAGGING_TYPE.

  CURSOR_TYPE* = enum
    CURSOR_ARROW,             ## #0
    CURSOR_IBEAM,             ## #1
    CURSOR_WAIT,              ## #2
    CURSOR_CROSS,             ## #3
    CURSOR_UPARROW,           ## #4
    CURSOR_SIZENWSE,          ## #5
    CURSOR_SIZENESW,          ## #6
    CURSOR_SIZEWE,            ## #7
    CURSOR_SIZENS,            ## #8
    CURSOR_SIZEALL,           ## #9
    CURSOR_NO,                ## #10
    CURSOR_APPSTARTING,       ## #11
    CURSOR_HELP,              ## #12
    CURSOR_HAND,              ## #13
    CURSOR_DRAG_MOVE,         ## #14
    CURSOR_DRAG_COPY          ## #15


## # parameters of evtg == HANDLE_KEY

type
  KEY_EVENTS* = enum
    KEY_DOWN = 0, KEY_UP, KEY_CHAR


type
  KEY_PARAMS* = object
    cmd*: uint32               ## # KEY_EVENTS
    target*: HELEMENT          ## # target element
    key_code*: uint32          ## # key scan code, or character unicode for KEY_CHAR
    alt_state*: uint32         ## # KEYBOARD_STATES


## # parameters of evtg == HANDLE_FOCUS

type
  FOCUS_EVENTS* = enum
    FOCUS_LOST = 0,             ## # non-bubbling event, target is new focus element
    FOCUS_GOT = 1,              ## # non-bubbling event, target is old focus element
    FOCUS_IN = 2,               ## # bubbling event/notification, target is an element that got focus
    FOCUS_OUT = 3               ## # bubbling event/notification, target is an element that lost focus


type
  FOCUS_PARAMS* = object
    cmd*: uint32               ## # FOCUS_EVENTS
    target*: HELEMENT ## # target element, for FOCUS_LOST it is a handle of new focus element
                    ## #    and for FOCUS_GOT it is a handle of old focus element, can be NULL
    by_mouse_click*: bool      ## # true if focus is being set by mouse click
    cancel*: bool              ## # in FOCUS_LOST phase setting this field to true will cancel transfer focus from old element to the new one.


## # parameters of evtg == HANDLE_SCROLL

type
  SCROLL_EVENTS* = enum
    SCROLL_HOME = 0, SCROLL_END, SCROLL_STEP_PLUS, SCROLL_STEP_MINUS,
    SCROLL_PAGE_PLUS, SCROLL_PAGE_MINUS, SCROLL_POS, SCROLL_SLIDER_RELEASED,
    SCROLL_CORNER_PRESSED, SCROLL_CORNER_RELEASED


type
  SCROLL_PARAMS* = object
    cmd*: uint32               ## # SCROLL_EVENTS
    target*: HELEMENT          ## # target element
    pos*: int32                ## # scroll position if SCROLL_POS
    vertical*: bool            ## # true if from vertical scrollbar

  GESTURE_CMD* = enum
    GESTURE_REQUEST = 0,        ## # return true and fill flags if it will handle gestures.
    GESTURE_ZOOM,             ## # The zoom gesture.
    GESTURE_PAN,              ## # The pan gesture.
    GESTURE_ROTATE,           ## # The rotation gesture.
    GESTURE_TAP1,             ## # The tap gesture.
    GESTURE_TAP2              ## # The two-finger tap gesture.


type
  GESTURE_STATE* = enum
    GESTURE_STATE_BEGIN = 1,    ## # starts
    GESTURE_STATE_INERTIA = 2,  ## # events generated by inertia processor
    GESTURE_STATE_END = 4       ## # end, last event of the gesture sequence


type
  GESTURE_TYPE_FLAGS* = enum    ## # requested
    GESTURE_FLAG_ZOOM = 0x00000001, GESTURE_FLAG_ROTATE = 0x00000002,
    GESTURE_FLAG_PAN_VERTICAL = 0x00000004,
    GESTURE_FLAG_PAN_HORIZONTAL = 0x00000008, GESTURE_FLAG_TAP1 = 0x00000010, ## # press & tap
    GESTURE_FLAG_TAP2 = 0x00000020, ## # two fingers tap
    GESTURE_FLAG_PAN_WITH_GUTTER = 0x00004000, ## # PAN_VERTICAL and PAN_HORIZONTAL modifiers
    GESTURE_FLAG_PAN_WITH_INERTIA = 0x00008000, ## #
    GESTURE_FLAGS_ALL = 0x0000FFFF ## #


type
  GESTURE_PARAMS* = object
    cmd*: uint32               ## # GESTURE_EVENTS
    target*: HELEMENT          ## # target element
    pos*: Point                ## # position of cursor, element relative
    pos_view*: Point           ## # position of cursor, view relative
    flags*: uint32 ## # for GESTURE_REQUEST combination of GESTURE_FLAGs.
                ## # for others it is a combination of GESTURE_STATe's
    delta_time*: uint32        ## # period of time from previous event.
    delta_xy*: Size            ## # for GESTURE_PAN it is a direction vector
    delta_v*: float64          ## # for GESTURE_ROTATE - delta angle (radians)
                    ## # for GESTURE_ZOOM - zoom value, is less or greater than 1.0

  DRAW_EVENTS* = enum
    DRAW_BACKGROUND = 0, DRAW_CONTENT = 1, DRAW_FOREGROUND = 2


type
  DRAW_PARAMS* = object
    cmd*: uint32               ## # DRAW_EVENTS
    gfx*: HGFX                 ## # hdc to paint on
    area*: Rect                ## # element area, to get invalid area to paint use GetClipBox,
    reserved*: uint32 ## # for DRAW_BACKGROUND/DRAW_FOREGROUND - it is a border box
                    ## # for DRAW_CONTENT - it is a content box

  CONTENT_CHANGE_BITS* = enum   ## # for CONTENT_CHANGED reason
    CONTENT_ADDED = 0x00000001, CONTENT_REMOVED = 0x00000002


type
  BEHAVIOR_EVENTS* = enum
    BUTTON_CLICK = 0,           ## # click on button
    BUTTON_PRESS = 1,           ## # mouse down or key down in button
    BUTTON_STATE_CHANGED = 2,   ## # checkbox/radio/slider changed its state/value
    EDIT_VALUE_CHANGING = 3,    ## # before text change
    EDIT_VALUE_CHANGED = 4,     ## # after text change
    SELECT_SELECTION_CHANGED = 5, ## # selection in <select> changed
    SELECT_STATE_CHANGED = 6,   ## # node in select expanded/collapsed, heTarget is the node
    POPUP_REQUEST = 7,          ## # request to show popup just received,
                    ## #     here DOM of popup element can be modifed.
    POPUP_READY = 8, ## # popup element has been measured and ready to be shown on screen,
                  ## #     here you can use functions like ScrollToView.
    POPUP_DISMISSED = 9, ## # popup element is closed,
                      ## #     here DOM of popup element can be modifed again - e.g. some items can be removed
                      ## #     to free memory.
    MENU_ITEM_ACTIVE = 0x0000000A, ## # menu item activated by mouse hover or by keyboard,
    MENU_ITEM_CLICK = 0x0000000B, ## # menu item click,
                              ## #   BEHAVIOR_EVENT_PARAMS structure layout
                              ## #   BEHAVIOR_EVENT_PARAMS.cmd - MENU_ITEM_CLICK/MENU_ITEM_ACTIVE
                              ## #   BEHAVIOR_EVENT_PARAMS.heTarget - owner(anchor) of the menu
                              ## #   BEHAVIOR_EVENT_PARAMS.he - the menu item, presumably <li> element
                              ## #   BEHAVIOR_EVENT_PARAMS.reason - BY_MOUSE_CLICK | BY_KEY_CLICK
    CONTEXT_MENU_REQUEST = 0x00000010, ## # "right-click", BEHAVIOR_EVENT_PARAMS::he is current popup menu HELEMENT being processed or NULL.
                                    ## # application can provide its own HELEMENT here (if it is NULL) or modify current menu element.
    VISIUAL_STATUS_CHANGED = 0x00000011, ## # broadcast notification, sent to all elements of some container being shown or hidden
    DISABLED_STATUS_CHANGED = 0x00000012, ## # broadcast notification, sent to all elements of some container that got new value of :disabled state
    POPUP_DISMISSING = 0x00000013, ## # popup is about to be closed
    CONTENT_CHANGED = 0x00000015, ## # content has been changed, is posted to the element that gets content changed,  reason is combination of CONTENT_CHANGE_BITS.
                              ## # target == NULL means the window got new document and this event is dispatched only to the window.
    CLICK = 0x00000016,         ## # generic click
    CHANGE = 0x00000017,        ## # generic change
                      ## # "grey" event codes  - notfications from behaviors from this SDK
    HYPERLINK_CLICK = 0x00000080, ## # hyperlink click
                              ## #TABLE_HEADER_CLICK,            // click on some cell in table header,
                              ## #                               //     target = the cell,
                              ## #                               //     reason = index of the cell (column number, 0..n)
                              ## #TABLE_ROW_CLICK,               // click on data row in the table, target is the row
                              ## #                               //     target = the row,
                              ## #                               //     reason = index of the row (fixed_rows..n)
                              ## #TABLE_ROW_DBL_CLICK,           // mouse dbl click on data row in the table, target is the row
                              ## #                               //     target = the row,
                              ## #                               //     reason = index of the row (fixed_rows..n)
    ELEMENT_COLLAPSED = 0x00000090, ## # element was collapsed, so far only behavior:tabs is sending these two to the panels
    ELEMENT_EXPANDED,         ## # element was expanded,
    ACTIVATE_CHILD, ## # activate (select) child,
                  ## # used for example by accesskeys behaviors to send activation request, e.g. tab on behavior:tabs.
                  ## #DO_SWITCH_TAB = ACTIVATE_CHILD,// command to switch tab programmatically, handled by behavior:tabs
                  ## #                               // use it as SciterPostEvent(tabsElementOrItsChild, DO_SWITCH_TAB, tabElementToShow, 0);
    INIT_DATA_VIEW,           ## # request to virtual grid to initialize its view
    ROWS_DATA_REQUEST, ## # request from virtual grid to data source behavior to fill data in the table
                      ## # parameters passed throug DATA_ROWS_PARAMS structure.
    UI_STATE_CHANGED, ## # ui state changed, observers shall update their visual states.
                    ## # is sent for example by behavior:richtext when caret position/selection has changed.
    FORM_SUBMIT, ## # behavior:form detected submission event. BEHAVIOR_EVENT_PARAMS::data field contains data to be posted.
                ## # BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                ## # to be submitted. You can modify the data or discard submission by returning true from the handler.
    FORM_RESET, ## # behavior:form detected reset event (from button type=reset). BEHAVIOR_EVENT_PARAMS::data field contains data to be reset.
              ## # BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
              ## # to be rest. You can modify the data or discard reset by returning true from the handler.
    DOCUMENT_COMPLETE,        ## # document in behavior:frame or root document is complete.
    HISTORY_PUSH,             ## # requests to behavior:history (commands)
    HISTORY_DROP, HISTORY_PRIOR, HISTORY_NEXT, HISTORY_STATE_CHANGED, ## #
                                                                  ## behavior:history notification - history stack has changed
    CLOSE_POPUP,              ## # close popup request,
    REQUEST_TOOLTIP,          ## # request tooltip, evt.source <- is the tooltip element.
    ANIMATION = 0x000000A0,     ## # animation started (reason=1) or ended(reason=0) on the element.
    DOCUMENT_CREATED = 0x000000C0, ## # document created, script namespace initialized. target -> the document
    DOCUMENT_CLOSE_REQUEST = 0x000000C1, ## # document is about to be closed, to cancel closing do: evt.data = sciter::value("cancel");
    DOCUMENT_CLOSE = 0x000000C2, ## # last notification before document removal from the DOM
    DOCUMENT_READY = 0x000000C3, ## # document has got DOM structure, styles and behaviors of DOM elements. Script loading run is complete at this moment.
    VIDEO_INITIALIZED = 0x000000D1, ## # <video> "ready" notification
    VIDEO_STARTED = 0x000000D2, ## # <video> playback started notification
    VIDEO_STOPPED = 0x000000D3, ## # <video> playback stoped/paused notification
    VIDEO_BIND_RQ = 0x000000D4, ## # <video> request for frame source binding,
                            ## #   If you want to provide your own video frames source for the given target <video> element do the following:
                            ## #   1. Handle and consume this VIDEO_BIND_RQ request
                            ## #   2. You will receive second VIDEO_BIND_RQ request/event for the same <video> element
                            ## #      but this time with the 'reason' field set to an instance of sciter::video_destination interface.
                            ## #   3. add_ref() it and store it for example in worker thread producing video frames.
                            ## #   4. call sciter::video_destination::start_streaming(...) providing needed parameters
                            ## #      call sciter::video_destination::render_frame(...) as soon as they are available
                            ## #      call sciter::video_destination::stop_streaming() to stop the rendering (a.k.a. end of movie reached)
    PAGINATION_STARTS = 0x000000E0, ## # behavior:pager starts pagination
    PAGINATION_PAGE = 0x000000E1, ## # behavior:pager paginated page no, reason -> page no
    PAGINATION_ENDS = 0x000000E2, ## # behavior:pager end pagination, reason -> total pages
    FIRST_APPLICATION_EVENT_CODE = 0x00000100


type
  EVENT_REASON* = enum
    BY_MOUSE_CLICK, BY_KEY_CLICK, SYNTHESIZED ## # synthesized, programmatically generated.


type
  EDIT_CHANGED_REASON* = enum
    BY_INS_CHAR,              ## # single char insertion
    BY_INS_CHARS,             ## # character range insertion, clipboard
    BY_DEL_CHAR,              ## # single char deletion
    BY_DEL_CHARS              ## # character range deletion (selection)


type
  BEHAVIOR_EVENT_PARAMS* = object
    cmd*: uint32               ## # BEHAVIOR_EVENTS
    heTarget*: HELEMENT ## # target element handler, in MENU_ITEM_CLICK this is owner element that caused this menu - e.g. context menu owner
                      ## # In scripting this field named as Event.owner
    he*: HELEMENT              ## # source element e.g. in SELECTION_CHANGED it is new selected <option>, in MENU_ITEM_CLICK it is menu item (LI) element
    reason*: uint32 ## # EVENT_REASON or EDIT_CHANGED_REASON - UI action causing change.
                  ## # In case of custom event notifications this may be any
                  ## # application specific value.
    data*: Value               ## # auxiliary data accompanied with the event. E.g. FORM_SUBMIT event is using this field to pass collection of values.

  TIMER_PARAMS* = object
    timerId*: uint32           ## # timerId that was used to create timer by using SciterSetTimer


## # identifiers of methods currently supported by intrinsic behaviors,
## # see function SciterCallBehaviorMethod

type
  BEHAVIOR_METHOD_IDENTIFIERS* = enum
    DO_CLICK = 0, GET_TEXT_VALUE = 1, SET_TEXT_VALUE, ## # p - TEXT_VALUE_PARAMS
    TEXT_EDIT_GET_SELECTION,  ## # p - TEXT_EDIT_SELECTION_PARAMS
    TEXT_EDIT_SET_SELECTION, ## # p - TEXT_EDIT_SELECTION_PARAMS
                            ## # Replace selection content or insert text at current caret position.
                            ## # Replaced text will be selected.
    TEXT_EDIT_REPLACE_SELECTION, ## # p - TEXT_EDIT_REPLACE_SELECTION_PARAMS
                                ## # Set value of type="vscrollbar"/"hscrollbar"
    SCROLL_BAR_GET_VALUE, SCROLL_BAR_SET_VALUE, TEXT_EDIT_GET_CARET_POSITION, TEXT_EDIT_GET_SELECTION_TEXT, ##
                                                                                                        ## #
                                                                                                        ## p
                                                                                                        ## -
                                                                                                        ## TEXT_SELECTION_PARAMS
    TEXT_EDIT_GET_SELECTION_HTML, ## # p - TEXT_SELECTION_PARAMS
    TEXT_EDIT_CHAR_POS_AT_XY, ## # p - TEXT_EDIT_CHAR_POS_AT_XY_PARAMS
    IS_EMPTY = 0x000000FC,      ## # p - IS_EMPTY_PARAMS // set VALUE_PARAMS::is_empty (false/true) reflects :empty state of the element.
    GET_VALUE = 0x000000FD,     ## # p - VALUE_PARAMS
    SET_VALUE = 0x000000FE,     ## # p - VALUE_PARAMS
    FIRST_APPLICATION_METHOD_ID = 0x00000100


type
  SCRIPTING_METHOD_PARAMS* = object
    name*: cstring             ## #< method name
    argv*: ptr Value            ## #< vector of arguments
    argc*: uint32              ## #< argument count
    result*: Value             ## #< return value

  TISCRIPT_METHOD_PARAMS* = object
    vm*: ptr tiscript_VM
    tag*: tiscript_value       ## #< method id (symbol)
    result*: tiscript_value    ## #< return value
                          ## # parameters are accessible through tiscript::args.


## # GET_VALUE/SET_VALUE methods params

type
  VALUE_PARAMS* = object
    methodID*: uint32
    val*: Value
    invalid_field_to_bypass_c2nim*: byte


## # IS_EMPTY method params

type
  IS_EMPTY_PARAMS* = object
    methodID*: uint32
    is_empty*: uint32          ## # !0 - is empty
    invalid_field_to_bypass_c2nim*: byte


## # see SciterRequestElementData

type
  DATA_ARRIVED_PARAMS* = object
    initiator*: HELEMENT       ## # element intiator of SciterRequestElementData request,
    data*: pointer             ## # data buffer
    dataSize*: uint32          ## # size of data
    dataType*: uint32          ## # data type passed "as is" from SciterRequestElementData
    status*: uint32 ## # status = 0 (dataSize == 0) - unknown error.
                  ## # status = 100..505 - http response status, Note: 200 - OK!
                  ## # status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
    uri*: WideCString          ## # requested url
