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
## #  DOM access methods, plain C interface
## #

type
  HELEMENT* = distinct pointer

## #*DOM node handle.

type
  HNODE* = pointer

## #*DOM range handle.

type
  HRANGE* = pointer
  HSARCHIVE* = pointer
  HPOSITION* = object
    hn*: HNODE
    pos*: int32


## ##include <string>

## #*Type of the result value for Sciter DOM functions.
## #  Possible values are:
## #  - \b SCDOM_OK - function completed successfully
## #  - \b SCDOM_INVALID_HWND - invalid HWINDOW
## #  - \b SCDOM_INVALID_HANDLE - invalid HELEMENT
## #  - \b SCDOM_PASSIVE_HANDLE - attempt to use HELEMENT which is not marked by
## #    #Sciter_UseElement()
## #  - \b SCDOM_INVALID_PARAMETER - parameter is invalid, e.g. pointer is null
## #  - \b SCDOM_OPERATION_FAILED - operation failed, e.g. invalid html in
## #    #SciterSetElementHtml()
## #

const
  int32* = int32
  SCDOM_OK* = 0
  SCDOM_INVALID_HWND* = 1
  SCDOM_INVALID_HANDLE* = 2
  SCDOM_PASSIVE_HANDLE* = 3
  SCDOM_INVALID_PARAMETER* = 4
  SCDOM_OPERATION_FAILED* = 5
  SCDOM_OK_NOT_HANDLED* = (- 1)

type
  METHOD_PARAMS* = object
    methodID*: uint32

  REQUEST_PARAM* = object
    name*: WideCString
    value*: WideCString

  ELEMENT_AREAS* = enum
    CONTENT_BOX = 0x00000000,   ## # content (inner)  box
    ROOT_RELATIVE = 0x00000001, ## # - or this flag if you want to get Sciter window relative coordinates,
                            ## #   otherwise it will use nearest windowed container e.g. popup window.
    SELF_RELATIVE = 0x00000002, ## # - "or" this flag if you want to get coordinates relative to the origin
                            ## #   of element iself.
    CONTAINER_RELATIVE = 0x00000003, ## # - position inside immediate container.
    VIEW_RELATIVE = 0x00000004, ## # - position relative to view - Sciter window
    PADDING_BOX = 0x00000010,   ## # content + paddings
    BORDER_BOX = 0x00000020,    ## # content + paddings + border
    MARGIN_BOX = 0x00000030,    ## # content + paddings + border + margins
    BACK_IMAGE_AREA = 0x00000040, ## # relative to content origin - location of background image (if it set no-repeat)
    FORE_IMAGE_AREA = 0x00000050, ## # relative to content origin - location of foreground image (if it set no-repeat)
    SCROLLABLE_AREA = 0x00000060 ## # scroll_area - scrollable area in content box


type
  SCITER_SCROLL_FLAGS* = enum
    SCROLL_TO_TOP = 0x00000001, SCROLL_SMOOTH = 0x00000010


## #*Callback function used with #SciterVisitElement().

type
  SciterElementCallback* = proc (he: HELEMENT; param: pointer): bool {.stdcall.}
  SET_ELEMENT_HTML* = enum
    SIH_REPLACE_CONTENT = 0, SIH_INSERT_AT_START = 1, SIH_APPEND_AFTER_LAST = 2,
    SOH_REPLACE = 3, SOH_INSERT_BEFORE = 4, SOH_INSERT_AFTER = 5


## #*Element callback function for all types of events. Similar to WndProc
## #  \param tag \b LPVOID, tag assigned by SciterAttachElementProc function (like GWL_USERDATA)
## #  \param he \b HELEMENT, this element handle (like HWINDOW)
## #  \param evtg \b UINT, group identifier of the event, value is one of EVENT_GROUPS
## #  \param prms \b LPVOID, pointer to group specific parameters structure.
## #  \return TRUE if event was handled, FALSE otherwise.
## #

type
  ElementEventProc* = proc (tag: pointer; he: HELEMENT; evtg: uint32; prms: pointer): bool {.
      stdcall.}
  LPELEMENT_EVENT_PROC* = ptr ElementEventProc
  ELEMENT_STATE_BITS* = enum
    STATE_LINK = 0x00000001, STATE_HOVER = 0x00000002, STATE_ACTIVE = 0x00000004,
    STATE_FOCUS = 0x00000008, STATE_VISITED = 0x00000010, STATE_CURRENT = 0x00000020, ## #
                                                                            ## current
                                                                            ## (hot)
                                                                            ## item
    STATE_CHECKED = 0x00000040, ## # element is checked (or selected)
    STATE_DISABLED = 0x00000080, ## # element is disabled
    STATE_READONLY = 0x00000100, ## # readonly input element
    STATE_EXPANDED = 0x00000200, ## # expanded state - nodes in tree view
    STATE_COLLAPSED = 0x00000400, ## # collapsed state - nodes in tree view - mutually exclusive with
    STATE_INCOMPLETE = 0x00000800, ## # one of fore/back images requested but not delivered
    STATE_ANIMATING = 0x00001000, ## # is animating currently
    STATE_FOCUSABLE = 0x00002000, ## # will accept focus
    STATE_ANCHOR = 0x00004000,  ## # anchor in selection (used with current in selects)
    STATE_SYNTHETIC = 0x00008000, ## # this is a synthetic element - don't emit it's head/tail
    STATE_OWNS_POPUP = 0x00010000, ## # this is a synthetic element - don't emit it's head/tail
    STATE_TABFOCUS = 0x00020000, ## # focus gained by tab traversal
    STATE_EMPTY = 0x00040000, ## # empty - element is empty (text.size() == 0 && subs.size() == 0)
                          ## #  if element has behavior attached then the behavior is responsible for the value of this flag.
    STATE_BUSY = 0x00080000,    ## # busy; loading
    STATE_DRAG_OVER = 0x00100000, ## # drag over the block that can accept it (so is current drop target). Flag is set for the drop target block
    STATE_DROP_TARGET = 0x00200000, ## # active drop target.
    STATE_MOVING = 0x00400000,  ## # dragging/moving - the flag is set for the moving block.
    STATE_COPYING = 0x00800000, ## # dragging/copying - the flag is set for the copying block.
    STATE_DRAG_SOURCE = 0x01000000, ## # element that is a drag source.
    STATE_DROP_MARKER = 0x02000000, ## # element is drop marker
    STATE_PRESSED = 0x04000000, ## # pressed - close to active but has wider life span - e.g. in MOUSE_UP it
                            ## #   is still on; so behavior can check it in MOUSE_UP to discover CLICK condition.
    STATE_POPUP = 0x08000000,   ## # this element is out of flow - popup
    STATE_IS_LTR = 0x10000000,  ## # the element or one of its containers has dir=ltr declared
    STATE_IS_RTL = 0x20000000   ## # the element or one of its containers has dir=rtl declared


type
  REQUEST_TYPE* = enum
    GET_ASYNC,                ## # async GET
    POST_ASYNC,               ## # async POST
    GET_SYNC,                 ## # synchronous GET
    POST_SYNC                 ## # synchronous POST


## #*Callback comparator function used with #SciterSortElements().
## #   Shall return -1,0,+1 values to indicate result of comparison of two elements
## #

type
  ELEMENT_COMPARATOR* = proc (he1: HELEMENT; he2: HELEMENT; param: pointer): int32 {.
      stdcall.}
  CTL_TYPE* = enum
    CTL_NO,                   ## #/< This dom element has no behavior at all.
    CTL_EDIT,                 ## #/< Single line edit box.
    CTL_NUMERIC,              ## #/< Numeric input with optional spin buttons.
    CTL_CLICKABLE,            ## #/< toolbar button, behavior:clickable.
    CTL_BUTTON,               ## #/< Command button.
    CTL_CHECKBOX,             ## #/< CheckBox (button).
    CTL_RADIO,                ## #/< OptionBox (button).
    CTL_SELECT_SINGLE,        ## #/< Single select, ListBox or TreeView.
    CTL_SELECT_MULTIPLE,      ## #/< Multiselectable select, ListBox or TreeView.
    CTL_DD_SELECT,            ## #/< Dropdown single select.
    CTL_TEXTAREA,             ## #/< Multiline TextBox.
    CTL_HTMLAREA,             ## #/< WYSIWYG HTML editor.
    CTL_PASSWORD,             ## #/< Password input element.
    CTL_PROGRESS,             ## #/< Progress element.
    CTL_SLIDER,               ## #/< Slider input element.
    CTL_DECIMAL,              ## #/< Decimal number input element.
    CTL_CURRENCY,             ## #/< Currency input element.
    CTL_SCROLLBAR, CTL_HYPERLINK, CTL_MENUBAR, CTL_MENU, CTL_MENUBUTTON,
    CTL_CALENDAR, CTL_DATE, CTL_TIME, CTL_FRAME, CTL_FRAMESET, CTL_GRAPHICS,
    CTL_SPRITE, CTL_LIST, CTL_RICHTEXT, CTL_TOOLTIP, CTL_HIDDEN, CTL_URL, ## #/< URL input element.
    CTL_TOOLBAR, CTL_FORM, CTL_FILE, ## #/< file input element.
    CTL_PATH,                 ## #/< path input element.
    CTL_WINDOW,               ## #/< has HWND attached to it
    CTL_LABEL, CTL_IMAGE       ## #/< image/object.

const
  CTL_UNKNOWN = CTL_NO          ## #/< This dom element has no behavior at all.

type
  NODE_TYPE* = enum
    NT_ELEMENT, NT_TEXT, NT_COMMENT


type
  NODE_INS_TARGET* = enum
    NIT_BEFORE, NIT_AFTER, NIT_APPEND, NIT_PREPEND
