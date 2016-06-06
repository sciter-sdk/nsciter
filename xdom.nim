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

import xtypes
type
  HELEMENT* = pointer

## #*DOM node handle.

type
  HNODE* = pointer

## #*DOM range handle.

type
  HRANGE* = pointer
  HSARCHIVE* = pointer
  HPOSITION* = object
    hn*: HNODE
    pos*: cint


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
  SCDOM_OK* = 0
  SCDOM_INVALID_HWND* = 1
  SCDOM_INVALID_HANDLE* = 2
  SCDOM_PASSIVE_HANDLE* = 3
  SCDOM_INVALID_PARAMETER* = 4
  SCDOM_OPERATION_FAILED* = 5
  SCDOM_OK_NOT_HANDLED* = (- 1)

type
  METHOD_PARAMS* = object
    methodID*: cuint

  REQUEST_PARAM* = object
    name*: ptr WideCString
    value*: ptr WideCString


proc Sciter_UseElement*(he: HELEMENT): cint
## #*Marks DOM object as unused (a.k.a. Release).
## #  Get handle of every element's child element.
## #  \param[in] he \b #HELEMENT
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  Application should call this function when it does not need element's
## #  handle anymore.
## #  \sa #Sciter_UseElement()
## # 

proc Sciter_UnuseElement*(he: HELEMENT): cint
## #*Get root DOM element of HTML document.
## #  \param[in] hwnd \b HWINDOW, Sciter window for which you need to get root
## #  element
## #  \param[out ] phe \b #HELEMENT*, variable to receive root element
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  Root DOM object is always a 'HTML' element of the document.
## # 

proc SciterGetRootElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint
## #*Get focused DOM element of HTML document.
## #  \param[in] hwnd \b HWINDOW, Sciter window for which you need to get focus
## #  element
## #  \param[out ] phe \b #HELEMENT*, variable to receive focus element
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  phe can have null value (0).
## # 
## #  COMMENT: To set focus on element use SciterSetElementState(STATE_FOCUS,0)
## # 

proc SciterGetFocusElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint
## #*Find DOM element by coordinate.
## #  \param[in] hwnd \b HWINDOW, Sciter window for which you need to find
## #  elementz
## #  \param[in] pt \b POINT, coordinates, window client area relative.
## #  \param[out ] phe \b #HELEMENT*, variable to receive found element handle.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  If element was not found then *phe will be set to zero.
## # 

proc SciterFindElement*(hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): cint
## #*Get number of child elements.
## #  \param[in] he \b #HELEMENT, element which child elements you need to count
## #  \param[out] count \b UINT*, variable to receive number of child elements
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  \par Example:
## #  for paragraph defined as
## #  \verbatim <p>Hello <b>wonderfull</b> world!</p> \endverbatim
## #  count will be set to 1 as the paragraph has only one sub element:
## #  \verbatim <b>wonderfull</b> \endverbatim
## # 

proc SciterGetChildrenCount*(he: HELEMENT; count: ptr cuint): cint
## #*Get handle of every element's child element.
## #  \param[in] he \b #HELEMENT
## #  \param[in] n \b UINT, number of the child element
## #  \param[out] phe \b #HELEMENT*, variable to receive handle of the child
## #  element
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  \par Example:
## #  for paragraph defined as
## #  \verbatim <p>Hello <b>wonderfull</b> world!</p> \endverbatim
## #  *phe will be equal to handle of &lt;b&gt; element:
## #  \verbatim <b>wonderfull</b> \endverbatim
## # 

proc SciterGetNthChild*(he: HELEMENT; n: cuint; phe: ptr HELEMENT): cint
## #*Get parent element.
## #  \param[in] he \b #HELEMENT, element which parent you need
## #  \param[out] p_parent_he \b #HELEMENT*, variable to recieve handle of the
## #  parent element
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetParentElement*(he: HELEMENT; p_parent_he: ptr HELEMENT): cint
## #* Get html representation of the element.
## #  \param[in] he \b #HELEMENT
## #  \param[in] outer \b BOOL, if TRUE will retunr outer HTML otherwise inner.
## #  \param[in] rcv \b pointer to function receiving UTF8 encoded HTML.
## #  \param[in] rcv_param \b parameter that passed to rcv as it is.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetElementHtmlCB*(he: HELEMENT; outer: bool; rcv: ptr LPCBYTE_RECEIVER;
                            rcv_param: pointer): cint
## #*Get inner text of the element as LPWSTR (utf16 words).
## #  \param[in] he \b #HELEMENT
## #  \param[out] utf16words \b pointer to byte address receiving UTF16 encoded plain text
## #  \return \b #SCDOM_RESULT SCAPI
## #  OBSOLETE! use SciterGetElementTextCB instead
## # 
## #OBSOLETE SCDOM_RESULT SCAPI SciterGetElementText(HELEMENT he, LPWSTR* utf16);
## #*Get inner text of the element as LPCWSTR (utf16 words).
## #  \param[in] he \b #HELEMENT
## #  \param[in] rcv \b pointer to the function receiving UTF16 encoded plain text
## #  \param[in] rcv_param \b param passed that passed to LPCWSTR_RECEIVER "as is"
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetElementTextCB*(he: HELEMENT; rcv: ptr LPCWSTR_RECEIVER;
                            rcv_param: pointer): cint
## #*Set inner text of the element from LPCWSTR buffer (utf16 words).
## #  \param[in] he \b #HELEMENT
## #  \param[in] utf16words \b pointer, UTF16 encoded plain text
## #  \param[in] length \b UINT, number of words in utf16words sequence
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterSetElementText*(he: HELEMENT; utf16: ptr WideCString; length: cuint): cint
## #*Get number of element's attributes.
## #  \param[in] he \b #HELEMENT
## #  \param[out] p_count \b LPUINT, variable to receive number of element
## #  attributes.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetAttributeCount*(he: HELEMENT; p_count: ptr cuint): cint
## #*Get value of any element's attribute by attribute's number.
## #  \param[in] he \b #HELEMENT
## #  \param[in] n \b UINT, number of desired attribute
## #  \param[out] p_name \b LPCSTR*, will be set to address of the string
## #  containing attribute name
## #  \param[out] p_value \b LPCWSTR*, will be set to address of the string
## #  containing attribute value
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetNthAttributeNameCB*(he: HELEMENT; n: cuint; rcv: ptr LPCSTR_RECEIVER;
                                 rcv_param: pointer): cint
proc SciterGetNthAttributeValueCB*(he: HELEMENT; n: cuint; rcv: ptr LPCWSTR_RECEIVER;
                                  rcv_param: pointer): cint
## #*Get value of any element's attribute by name.
## #  \param[in] he \b #HELEMENT
## #  \param[in] name \b LPCSTR, attribute name
## #  \param[out] p_value \b LPCWSTR*, will be set to address of the string
## #  containing attribute value
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #SCDOM_RESULT SCAPI SciterGetAttributeByName(HELEMENT he, LPCSTR name, LPCWSTR* p_value);

proc SciterGetAttributeByNameCB*(he: HELEMENT; name: cstring;
                                rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint
## #*Set attribute's value.
## #  \param[in] he \b #HELEMENT
## #  \param[in] name \b LPCSTR, attribute name
## #  \param[in] value \b LPCWSTR, new attribute value or 0 if you want to remove attribute.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterSetAttributeByName*(he: HELEMENT; name: cstring; value: ptr WideCString): cint
## #*Remove all attributes from the element.
## #  \param[in] he \b #HELEMENT
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterClearAttributes*(he: HELEMENT): cint
## #*Get element index.
## #  \param[in] he \b #HELEMENT
## #  \param[out] p_index \b LPUINT, variable to receive number of the element
## #  among parent element's subelements.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetElementIndex*(he: HELEMENT; p_index: ptr cuint): cint
## #*Get element's type.
## #  \param[in] he \b #HELEMENT
## #  \param[out] p_type \b LPCSTR*, receives name of the element type.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  \par Example:
## #  For &lt;div&gt; tag p_type will be set to "div".
## # 

proc SciterGetElementType*(he: HELEMENT; p_type: cstringArray): cint
## #*Get element's type.
## #  \param[in] he \b #HELEMENT
## #  \param[out] rcv \b LPCSTR_RECEIVER, receives name of the element type.
## #  \param[out] rcv_param \b LPVOID, parameter passed as it is to the receiver.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## # 

proc SciterGetElementTypeCB*(he: HELEMENT; rcv: ptr LPCSTR_RECEIVER;
                            rcv_param: pointer): cint
## #*Get element's style attribute.
## #  \param[in] he \b #HELEMENT
## #  \param[in] name \b LPCSTR, name of the style attribute
## #  \param[in] rcv \b pointer to the function receiving UTF16 encoded plain text
## #  \param[in] rcv_param \b param passed that passed to LPCWSTR_RECEIVER "as is"
## # 
## #  Style attributes are those that are set using css. E.g. "font-face: arial" or "display: block".
## # 
## #  \sa #SciterSetStyleAttribute()
## # 

proc SciterGetStyleAttributeCB*(he: HELEMENT; name: cstring;
                               rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint
## #*Get element's style attribute.
## #  \param[in] he \b #HELEMENT
## #  \param[in] name \b LPCSTR, name of the style attribute
## #  \param[out] value \b LPCWSTR, value of the style attribute.
## # 
## #  Style attributes are those that are set using css. E.g. "font-face: arial" or "display: block".
## # 
## #  \sa #SciterGetStyleAttribute()
## # 

proc SciterSetStyleAttribute*(he: HELEMENT; name: cstring; value: ptr WideCString): cint
## #Get bounding rectangle of the element.
## #  \param[in] he \b #HELEMENT
## #  \param[out] p_location \b LPRECT, receives bounding rectangle of the element
## #  \param[in] rootRelative \b BOOL, if TRUE function returns location of the
## #  element relative to Sciter window, otherwise the location is given
## #  relative to first scrollable container.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

type
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


proc SciterGetElementLocation*(he: HELEMENT; p_location: ptr Rect; areas: cuint): cint
  ## #ELEMENT_AREAS
type
  SCITER_SCROLL_FLAGS* = enum
    SCROLL_TO_TOP = 0x00000001, SCROLL_SMOOTH = 0x00000010


## #Scroll to view.
## #  \param[in] he \b #HELEMENT
## #  \param[in] SciterScrollFlags \b #UINT, combination of SCITER_SCROLL_FLAGS above or 0
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterScrollToView*(he: HELEMENT; SciterScrollFlags: cuint): cint
## #*Apply changes and refresh element area in its window.
## #  \param[in] he \b #HELEMENT
## #  \param[in] andForceRender \b BOOL, TRUE to force UpdateWindow() call.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterUpdateElement*(he: HELEMENT; andForceRender: bool): cint
## #*refresh element area in its window.
## #  \param[in] he \b #HELEMENT
## #  \param[in] rc \b RECT, rect to refresh.
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterRefreshElementArea*(he: HELEMENT; rc: Rect): cint
## #*Set the mouse capture to the specified element.
## #  \param[in] he \b #HELEMENT
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  After call to this function all mouse events will be targeted to the element.
## #  To remove mouse capture call ReleaseCapture() function.
## # 

proc SciterSetCapture*(he: HELEMENT): cint
proc SciterReleaseCapture*(he: HELEMENT): cint
## #*Get HWINDOW of containing window.
## #  \param[in] he \b #HELEMENT
## #  \param[out] p_hwnd \b HWINDOW*, variable to receive window handle
## #  \param[in] rootWindow \b BOOL, handle of which window to get:
## #  - TRUE - Sciter window
## #  - FALSE - nearest parent element having overflow:auto or :scroll
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterGetElementHwnd*(he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): cint
## #*Combine given URL with URL of the document element belongs to.
## #  \param[in] he \b #HELEMENT
## #  \param[in, out] szUrlBuffer \b LPWSTR, at input this buffer contains
## #  zero-terminated URL to be combined, after function call it contains
## #  zero-terminated combined URL
## #  \param[in] UrlBufferSize \b UINT, size of the buffer pointed by
## #  \c szUrlBuffer
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  This function is used for resolving relative references.
## # 

proc SciterCombineURL*(he: HELEMENT; szUrlBuffer: ptr WideCString;
                      UrlBufferSize: cuint): cint
## #*Callback function used with #SciterVisitElement().

type
  SciterElementCallback* = proc (he: HELEMENT; param: pointer): bool

## #*Call specified function for every element in a DOM that meets specified
## #  CSS selectors.
## #  See list of supported selectors: http://www.terrainformatica.com/sciter/css/selectors.htm
## #  \param[in] he \b #HELEMENT
## #  \param[in] selector \b LPCSTR, comma separated list of CSS selectors, e.g.: div, #id, div[align="right"].
## #  \param[in] callback \b #SciterElementCallback*, address of callback
## #  function being called on each element found.
## #  \param[in] param \b LPVOID, additional parameter to be passed to callback
## #  function.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## # 

proc SciterSelectElements*(he: HELEMENT; CSS_selectors: cstring;
                          callback: ptr SciterElementCallback; param: pointer): cint
proc SciterSelectElementsW*(he: HELEMENT; CSS_selectors: ptr WideCString;
                           callback: ptr SciterElementCallback; param: pointer): cint
## #*Find parent of the element by CSS selector.
## #  ATTN: function will test first element itself.
## #  See list of supported selectors: http://www.terrainformatica.com/sciter/css/selectors.htm
## #  \param[in] he \b #HELEMENT
## #  \param[in] selector \b LPCSTR, comma separated list of CSS selectors, e.g.: div, #id, div[align="right"].
## #  \param[out] heFound \b #HELEMENT*, address of result HELEMENT
## #  \param[in] depth \b LPVOID, depth of search, if depth == 1 then it will test only element itself.
## #                      Use depth = 1 if you just want to test he element for matching given CSS selector(s).
## #                      depth = 0 will scan the whole child parent chain up to the root.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## # 

proc SciterSelectParent*(he: HELEMENT; selector: cstring; depth: cuint;
                        heFound: ptr HELEMENT): cint
  ## #out
proc SciterSelectParentW*(he: HELEMENT; selector: ptr WideCString; depth: cuint;
                         heFound: ptr HELEMENT): cint
  ## #out
type
  SET_ELEMENT_HTML* = enum
    SIH_REPLACE_CONTENT = 0, SIH_INSERT_AT_START = 1, SIH_APPEND_AFTER_LAST = 2,
    SOH_REPLACE = 3, SOH_INSERT_BEFORE = 4, SOH_INSERT_AFTER = 5


## #*Set inner or outer html of the element.
## #  \param[in] he \b #HELEMENT
## #  \param[in] html \b LPCBYTE, UTF-8 encoded string containing html text
## #  \param[in] htmlLength \b UINT, length in bytes of \c html.
## #  \param[in] where \b UINT, possible values are:
## #  - SIH_REPLACE_CONTENT - replace content of the element
## #  - SIH_INSERT_AT_START - insert html before first child of the element
## #  - SIH_APPEND_AFTER_LAST - insert html after last child of the element
## # 
## #  - SOH_REPLACE - replace element by html, a.k.a. element.outerHtml = "something"
## #  - SOH_INSERT_BEFORE - insert html before the element
## #  - SOH_INSERT_AFTER - insert html after the element
## #    ATTN: SOH_*** operations do not work for inline elements like <SPAN>
## # 
## #  \return /b #SCDOM_RESULT SCAPI
## #  

proc SciterSetElementHtml*(he: HELEMENT; html: ptr byte; htmlLength: cuint; where: cuint): cint
## #* Element UID support functions.
## # 
## #   Element UID is unique identifier of the DOM element.
## #   UID is suitable for storing it in structures associated with the view/document.
## #   Access to the element using HELEMENT is more effective but table space of handles is limited.
## #   It is not recommended to store HELEMENT handles between function calls.
## # 
## #* Get Element UID.
## #  \param[in] he \b #HELEMENT
## #  \param[out] puid \b UINT*, variable to receive UID of the element.
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  This function retrieves element UID by its handle.
## # 
## # 

proc SciterGetElementUID*(he: HELEMENT; puid: ptr cuint): cint
## #* Get Element handle by its UID.
## #  \param[in] hwnd \b HWINDOW, HWINDOW of Sciter window
## #  \param[in] uid \b UINT
## #  \param[out] phe \b #HELEMENT*, variable to receive HELEMENT handle
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## #  This function retrieves element UID by its handle.
## # 
## # 

proc SciterGetElementByUID*(hwnd: HWINDOW; uid: cuint; phe: ptr HELEMENT): cint
## #* Shows block element (DIV) in popup window.
## #  \param[in] hePopup \b HELEMENT, element to show as popup
## #  \param[in] heAnchor \b HELEMENT, anchor element - hePopup will be shown near this element
## #  \param[in] placement \b UINT, values:
## #      2 - popup element below of anchor
## #      8 - popup element above of anchor
## #      4 - popup element on left side of anchor
## #      6 - popup element on right side of anchor
## #      ( see numpad on keyboard to get an idea of the numbers)
## #  \return \b #SCDOM_RESULT SCAPI
## # 
## # 

proc SciterShowPopup*(hePopup: HELEMENT; heAnchor: HELEMENT; placement: cuint): cint
## #* Shows block element (DIV) in popup window at given position.
## #  \param[in] hePopup \b HELEMENT, element to show as popup
## #  \param[in] pos \b POINT, popup element position, relative to origin of Sciter window.
## #  \param[in] animate \b BOOL, true if animation is needed.
## # 

proc SciterShowPopupAt*(hePopup: HELEMENT; pos: Point; animate: bool): cint
## #* Removes popup window.
## #  \param[in] he \b HELEMENT, element which belongs to popup window or popup element itself
## # 

proc SciterHidePopup*(he: HELEMENT): cint
## #*Element callback function for all types of events. Similar to WndProc
## #  \param tag \b LPVOID, tag assigned by SciterAttachElementProc function (like GWL_USERDATA)
## #  \param he \b HELEMENT, this element handle (like HWINDOW)
## #  \param evtg \b UINT, group identifier of the event, value is one of EVENT_GROUPS
## #  \param prms \b LPVOID, pointer to group specific parameters structure.
## #  \return TRUE if event was handled, FALSE otherwise.
## # 

type
  ElementEventProc* = proc (tag: pointer; he: HELEMENT; evtg: cuint; prms: pointer): bool
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


## #* Get/set state bits, stateBits*** accept or'ed values above
## #   

proc SciterGetElementState*(he: HELEMENT; pstateBits: ptr cuint): cint
## #*
## # 

proc SciterSetElementState*(he: HELEMENT; stateBitsToSet: cuint;
                           stateBitsToClear: cuint; updateView: bool): cint
## #* Create new element, the element is disconnected initially from the DOM.
## #    Element created with ref_count = 1 thus you \b must call Sciter_UnuseElement on returned handler.
## #  \param[in] tagname \b LPCSTR, html tag of the element e.g. "div", "option", etc.
## #  \param[in] textOrNull \b LPCWSTR, initial text of the element or NULL. text here is a plain text - method does no parsing.
## #  \param[out ] phe \b #HELEMENT*, variable to receive handle of the element
## #  

proc SciterCreateElement*(tagname: cstring; textOrNull: ptr WideCString;
                         phe: ptr HELEMENT): cint
  ## #out
## #* Create new element as copy of existing element, new element is a full (deep) copy of the element and
## #    is disconnected initially from the DOM.
## #    Element created with ref_count = 1 thus you \b must call Sciter_UnuseElement on returned handler.
## #  \param[in] he \b #HELEMENT, source element.
## #  \param[out ] phe \b #HELEMENT*, variable to receive handle of the new element.
## #  

proc SciterCloneElement*(he: HELEMENT; phe: ptr HELEMENT): cint
  ## #out
## #* Insert element at \i index position of parent.
## #    It is not an error to insert element which already has parent - it will be disconnected first, but
## #    you need to update elements parent in this case.
## #  \param index \b UINT, position of the element in parent collection.
## #   It is not an error to provide index greater than elements count in parent -
## #   it will be appended.
## # 

proc SciterInsertElement*(he: HELEMENT; hparent: HELEMENT; index: cuint): cint
## #* Take element out of its container (and DOM tree).
## #    Element will be destroyed when its reference counter will become zero
## # 

proc SciterDetachElement*(he: HELEMENT): cint
## #* Take element out of its container (and DOM tree) and force destruction of all behaviors.
## #    Element will be destroyed when its reference counter will become zero
## # 

proc SciterDeleteElement*(he: HELEMENT): cint
## #* Start Timer for the element.
## #    Element will receive on_timer event
## #    To stop timer call SciterSetTimer( he, 0 );
## # 

proc SciterSetTimer*(he: HELEMENT; milliseconds: cuint; timer_id: csize): cint
## #* Attach/Detach ElementEventProc to the element
## #    See sciter::event_handler.
## # 

proc SciterDetachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint
## #* Attach ElementEventProc to the element and subscribe it to events providede by subscription parameter
## #    See Sciter::attach_event_handler.
## # 

proc SciterAttachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint
## #* Attach/Detach ElementEventProc to the Sciter window.
## #    All events will start first here (in SINKING phase) and if not consumed will end up here.
## #    You can install Window EventHandler only once - it will survive all document reloads.
## # 

proc SciterWindowAttachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer;
                                    subscription: cuint): cint
proc SciterWindowDetachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer): cint
## #* SendEvent - sends sinking/bubbling event to the child/parent chain of he element.
## #    First event will be send in SINKING mode (with SINKING flag) - from root to he element itself.
## #    Then from he element to its root on parents chain without SINKING flag (bubbling phase).
## #
## #  \param[in] he \b HELEMENT, element to send this event to.
## #  \param[in] appEventCode \b UINT, event ID, see: #BEHAVIOR_EVENTS
## #  \param[in] heSource \b HELEMENT, optional handle of the source element, e.g. some list item
## #  \param[in] reason \b UINT, notification specific event reason code
## #  \param[out] handled \b BOOL*, variable to receive TRUE if any handler handled it, FALSE otherwise.
## #
## # 

proc SciterSendEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint; handled: ptr bool): cint
  ## #out
## #* PostEvent - post sinking/bubbling event to the child/parent chain of he element.
## #   Function will return immediately posting event into input queue of the application.
## # 
## #  \param[in] he \b HELEMENT, element to send this event to.
## #  \param[in] appEventCode \b UINT, event ID, see: #BEHAVIOR_EVENTS
## #  \param[in] heSource \b HELEMENT, optional handle of the source element, e.g. some list item
## #  \param[in] reason \b UINT, notification specific event reason code
## #
## # 

proc SciterPostEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint): cint
proc SciterFireEvent*(evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool; handled: ptr bool): cint
## #* SciterCallMethod - calls behavior specific method.
## #  \param[in] he \b HELEMENT, element - source of the event.
## #  \param[in] params \b METHOD_PARAMS, pointer to method param block
## # 

proc SciterCallBehaviorMethod*(he: HELEMENT; params: ptr METHOD_PARAMS): cint
## #* SciterRequestElementData  - request data download for the element.
## #  \param[in] he \b HELEMENT, element to deleiver data to.
## #  \param[in] url \b LPCWSTR, url to download data from.
## #  \param[in] dataType \b UINT, data type, see SciterResourceType.
## #  \param[in] hInitiator \b HELEMENT, element - initiator, can be NULL.
## #
## #  event handler on the he element (if any) will be notified
## #  when data will be ready by receiving HANDLE_DATA_DELIVERY event.
## #
## #  

proc SciterRequestElementData*(he: HELEMENT; url: ptr WideCString; dataType: cuint;
                              initiator: HELEMENT): cint
## #*
## #   SciterSendRequest - send GET or POST request for the element
## # 
## #  event handler on the 'he' element (if any) will be notified
## #  when data will be ready by receiving HANDLE_DATA_DELIVERY event.
## # 
## # 

type
  REQUEST_TYPE* = enum
    GET_ASYNC,                ## # async GET
    POST_ASYNC,               ## # async POST
    GET_SYNC,                 ## # synchronous GET
    POST_SYNC                 ## # synchronous POST


## #struct REQUEST_PARAM { LPCWSTR name; LPCWSTR value; };

proc SciterHttpRequest*(he: HELEMENT; url: ptr WideCString; dataType: cuint;
                       requestType: cuint; requestParams: ptr REQUEST_PARAM; nParams: cuint): cint
  ## # element to deliver data
  ## # url
  ## # data type, see SciterResourceType.
  ## # one of REQUEST_TYPE values
  ## # parameters
  ## # number of parameters
## #* SciterGetScrollInfo  - get scroll info of element with overflow:scroll or auto.
## #  \param[in] he \b HELEMENT, element.
## #  \param[out] scrollPos \b LPPOINT, scroll position.
## #  \param[out] viewRect \b LPRECT, position of element scrollable area, content box minus scrollbars.
## #  \param[out] contentSize \b LPSIZE, size of scrollable element content.
## # 

proc SciterGetScrollInfo*(he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                         contentSize: ptr Size): cint
## #* SciterSetScrollPos  - set scroll position of element with overflow:scroll or auto.
## #  \param[in] he \b HELEMENT, element.
## #  \param[in] scrollPos \b POINT, new scroll position.
## #  \param[in] smooth \b BOOL, TRUE - do smooth scroll.
## # 

proc SciterSetScrollPos*(he: HELEMENT; scrollPos: Point; smooth: bool): cint
## #* SciterGetElementIntrinsicWidths  - get min-intrinsic and max-intrinsic widths of the element.
## #  \param[in] he \b HELEMENT, element.
## #  \param[out] pMinWidth \b INT*, calculated min-intrinsic width.
## #  \param[out] pMaxWidth \b INT*, calculated max-intrinsic width.
## # 

proc SciterGetElementIntrinsicWidths*(he: HELEMENT; pMinWidth: ptr cint;
                                     pMaxWidth: ptr cint): cint
## #* SciterGetElementIntrinsicHeight  - get min-intrinsic height of the element calculated for forWidth.
## #  \param[in] he \b HELEMENT, element.
## #  \param[in] forWidth \b INT*, width to calculate intrinsic height for.
## #  \param[out] pHeight \b INT*, calculated min-intrinsic height.
## # 

proc SciterGetElementIntrinsicHeight*(he: HELEMENT; forWidth: cint; pHeight: ptr cint): cint
## #* SciterIsElementVisible - deep visibility, determines if element visible - has no visiblity:hidden and no display:none defined
## #    for itself or for any its parents.
## #  \param[in] he \b HELEMENT, element.
## #  \param[out] pVisible \b LPBOOL, visibility state.
## # 

proc SciterIsElementVisible*(he: HELEMENT; pVisible: ptr bool): cint
## #* SciterIsElementEnabled - deep enable state, determines if element enabled - is not disabled by itself or no one
## #    of its parents is disabled.
## #  \param[in] he \b HELEMENT, element.
## #  \param[out] pEnabled \b LPBOOL, enabled state.
## # 

proc SciterIsElementEnabled*(he: HELEMENT; pEnabled: ptr bool): cint
## #*Callback comparator function used with #SciterSortElements().
## #   Shall return -1,0,+1 values to indicate result of comparison of two elements
## # 

type
  ELEMENT_COMPARATOR* = proc (he1: HELEMENT; he2: HELEMENT; param: pointer): cint

## #* SciterSortElements - sort children of the element.
## #  \param[in] he \b HELEMENT, element which children to be sorted.
## #  \param[in] firstIndex \b UINT, first child index to start sorting from.
## #  \param[in] lastIndex \b UINT, last index of the sorting range, element with this index will not be included in the sorting.
## #  \param[in] cmpFunc \b ELEMENT_COMPARATOR, comparator function.
## #  \param[in] cmpFuncParam \b LPVOID, parameter to be passed in comparator function.
## # 

proc SciterSortElements*(he: HELEMENT; firstIndex: cuint; lastIndex: cuint;
                        cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): cint
## #* SciterSwapElements - swap element positions.
## #  Function changes "insertion points" of two elements. So it swops indexes and parents of two elements.
## #  \param[in] he1 \b HELEMENT, first element.
## #  \param[in] he2 \b HELEMENT, second element.
## # 

proc SciterSwapElements*(he1: HELEMENT; he2: HELEMENT): cint
## #* SciterTraverseUIEvent - traverse (sink-and-bubble) MOUSE or KEY event.
## #  \param[in] evt \b EVENT_GROUPS, either HANDLE_MOUSE or HANDLE_KEY code.
## #  \param[in] eventCtlStruct \b LPVOID, pointer on either MOUSE_PARAMS or KEY_PARAMS structure.
## #  \param[out] bOutProcessed \b LPBOOL, pointer to BOOL receiving TRUE if event was processed by some element and FALSE otherwise.
## # 

proc SciterTraverseUIEvent*(evt: cuint; eventCtlStruct: pointer;
                           bOutProcessed: ptr bool): cint
## #* CallScriptingMethod - calls scripting method defined for the element.
## #  \param[in] he \b HELEMENT, element which method will be callled.
## #  \param[in] name \b LPCSTR, name of the method to call.
## #  \param[in] argv \b SCITER_VALUE[], vector of arguments.
## #  \param[in] argc \b UINT, number of arguments.
## #  \param[out] retval \b SCITER_VALUE*, pointer to SCITER_VALUE receiving returning value of the function.
## # 

proc SciterCallScriptingMethod*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                               argc: cuint; retval: ptr VALUE): cint
## #* CallScriptingFunction - calls scripting function defined in the namespace of the element (a.k.a. global function).
## #  \param[in] he \b HELEMENT, element which namespace will be used.
## #  \param[in] name \b LPCSTR, name of the method to call.
## #  \param[in] argv \b SCITER_VALUE[], vector of arguments.
## #  \param[in] argc \b UINT, number of arguments.
## #  \param[out] retval \b SCITER_VALUE*, pointer to SCITER_VALUE receiving returning value of the function.
## # 
## #  SciterCallScriptingFunction allows to call functions defined on global level of main document or frame loaded in it.
## # 
## # 

proc SciterCallScriptingFunction*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                                 argc: cuint; retval: ptr VALUE): cint
proc SciterEvalElementScript*(he: HELEMENT; script: ptr WideCString;
                             scriptLength: cuint; retval: ptr VALUE): cint
## #*Attach HWINDOW to the element.
## #  \param[in] he \b #HELEMENT
## #  \param[in] hwnd \b HWINDOW, window handle to attach
## #  \return \b #SCDOM_RESULT SCAPI
## # 

proc SciterAttachHwndToElement*(he: HELEMENT; hwnd: HWINDOW): cint
## #* Control types.
## #   Control here is any dom element having appropriate behavior applied
## # 

type
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

## #* SciterControlGetType - get type of control - type of behavior assigned to the element.
## #  \param[in] he \b HELEMENT, element.
## #  \param[out] pType \b UINT*, pointer to variable receiving control type,
## #              for list of values see CTL_TYPE.
## # 

proc SciterControlGetType*(he: HELEMENT; pType: ptr cuint): cint
  ## #CTL_TYPE
## #* SciterGetValue - get value of the element. 'value' is value of correspondent behavior attached to the element or its text.
## #  \param[in] he \b HELEMENT, element which value will be retrieved.
## #  \param[out] pval \b VALUE*, pointer to VALUE that will get elements value.
## #   ATTN: if you are not using json::value wrapper then you shall call ValueClear aginst the returned value
## #         otherwise memory will leak.
## # 

proc SciterGetValue*(he: HELEMENT; pval: ptr VALUE): cint
## #* SciterSetValue - set value of the element.
## #  \param[in] he \b HELEMENT, element which value will be changed.
## #  \param[in] pval \b VALUE*, pointer to the VALUE to set.
## # 

proc SciterSetValue*(he: HELEMENT; pval: ptr VALUE): cint
## #* SciterGetExpando - get 'expando' of the element. 'expando' is a scripting object (of class Element)
## #   that is assigned to the DOM element. 'expando' could be null as they are created on demand by script.
## #  \param[in] he \b HELEMENT, element which expando will be retrieved.
## #  \param[out] pval \b VALUE*, pointer to VALUE that will get value of type T_OBJECT/UT_OBJECT_NATIVE or null.
## #  \param[in] forceCreation \b BOOL, if there is no expando then when forceCreation==TRUE the function will create it.
## #   ATTN: if you are not using json::value wrapper then you shall call ValueClear aginst the returned value
## #         otherwise it will leak memory.
## # 

proc SciterGetExpando*(he: HELEMENT; pval: ptr VALUE; forceCreation: bool): cint
## #* SciterGetObject - get 'expando' object of the element. 'expando' is a scripting object (of class Element)
## #   that is assigned to the DOM element. 'expando' could be null as they are created on demand by script.
## #  \param[in] he \b HELEMENT, element which expando will be retrieved.
## #  \param[out] pval \b tiscript::value*, pointer to tiscript::value that will get reference to the scripting object associated wuth the element or null.
## #  \param[in] forceCreation \b BOOL, if there is no expando then when forceCreation==TRUE the function will create it.
## # 
## #   ATTN!: if you plan to store the reference or use it inside code that calls script VM functions
## #          then you should use tiscript::pinned holder for the value.
## # 

proc SciterGetObject*(he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): cint
## #* SciterGetElementNamespace - get namespace of document of the DOM element.
## #  \param[in] he \b HELEMENT, element which expando will be retrieved.
## #  \param[out] pval \b tiscript::value*, pointer to tiscript::value that will get reference to the namespace scripting object.
## # 
## #   ATTN!: if you plan to store the reference or use it inside code that calls script VM functions
## #          then you should use tiscript::pinned holder for the value.
## # 

proc SciterGetElementNamespace*(he: HELEMENT; pval: ptr tiscript_value): cint
## # get/set highlighted element. Used for debugging purposes.

proc SciterGetHighlightedElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint
proc SciterSetHighlightedElement*(hwnd: HWINDOW; he: HELEMENT): cint
## #|
## #| Nodes API
## #|
## # ATTENTION: node handles returned by functions below are not AddRef'ed

proc SciterNodeAddRef*(hn: HNODE): cint
proc SciterNodeRelease*(hn: HNODE): cint
proc SciterNodeCastFromElement*(he: HELEMENT; phn: ptr HNODE): cint
proc SciterNodeCastToElement*(hn: HNODE; he: ptr HELEMENT): cint
proc SciterNodeFirstChild*(hn: HNODE; phn: ptr HNODE): cint
proc SciterNodeLastChild*(hn: HNODE; phn: ptr HNODE): cint
proc SciterNodeNextSibling*(hn: HNODE; phn: ptr HNODE): cint
proc SciterNodePrevSibling*(hn: HNODE; phn: ptr HNODE): cint
proc SciterNodeParent*(hnode: HNODE; pheParent: ptr HELEMENT): cint
proc SciterNodeNthChild*(hnode: HNODE; n: cuint; phn: ptr HNODE): cint
proc SciterNodeChildrenCount*(hnode: HNODE; pn: ptr cuint): cint
type
  NODE_TYPE* = enum
    NT_ELEMENT, NT_TEXT, NT_COMMENT


proc SciterNodeType*(hnode: HNODE; pNodeType: ptr cuint): cint
  ## #NODE_TYPE
proc SciterNodeGetText*(hnode: HNODE; rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint
proc SciterNodeSetText*(hnode: HNODE; text: ptr WideCString; textLength: cuint): cint
type
  NODE_INS_TARGET* = enum
    NIT_BEFORE, NIT_AFTER, NIT_APPEND, NIT_PREPEND


proc SciterNodeInsert*(hnode: HNODE; where: cuint; ## #NODE_INS_TARGET
                      what: HNODE): cint
## # remove the node from the DOM, use finalize=FALSE if you plan to attach the node to the DOM later.

proc SciterNodeRemove*(hnode: HNODE; finalize: bool): cint
## # ATTENTION: node handles returned by these two functions are AddRef'ed

proc SciterCreateTextNode*(text: ptr WideCString; textLength: cuint; phnode: ptr HNODE): cint
proc SciterCreateCommentNode*(text: ptr WideCString; textLength: cuint;
                             phnode: ptr HNODE): cint