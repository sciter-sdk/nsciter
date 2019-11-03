## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## #
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## #
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## #

## #* #SC_LOAD_DATA notification return codes

type
  SC_LOAD_DATA_RETURN_CODES* = enum
    LOAD_OK = 0,                ## #*< do default loading if data not set
    LOAD_DISCARD = 1,           ## #*< discard request completely
    LOAD_DELAYED = 2, ## #*< data will be delivered later by the host application.
                  ## #                         Host application must call SciterDataReadyAsync(,,, requestId) on each LOAD_DELAYED request to avoid memory leaks.
    LOAD_MYSELF = 3 ## #*< you return LOAD_MYSELF result to indicate that your (the host) application took or will take care about HREQUEST in your code completely.
                ## #                         Use sciter-x-request.h[pp] API functions with SCN_LOAD_DATA::requestId handle .


## #*Notifies that Sciter is about to download a referred resource.
## #
## #  \param lParam #LPSCN_LOAD_DATA.
## #  \return #SC_LOAD_DATA_RETURN_CODES
## #
## #  This notification gives application a chance to override built-in loader and
## #  implement loading of resources in its own way (for example images can be loaded from
## #  database or other resource). To do this set #SCN_LOAD_DATA::outData and
## #  #SCN_LOAD_DATA::outDataSize members of SCN_LOAD_DATA. Sciter does not
## #  store pointer to this data. You can call #SciterDataReady() function instead
## #  of filling these fields. This allows you to free your outData buffer
## #  immediately.
## #

const
  SC_LOAD_DATA* = 0x00000001

## #*This notification indicates that external data (for example image) download process
## #  completed.
## #
## #  \param lParam #LPSCN_DATA_LOADED
## #
## #  This notifiaction is sent for each external resource used by document when
## #  this resource has been completely downloaded. Sciter will send this
## #  notification asynchronously.
## #

const
  SC_DATA_LOADED* = 0x00000002

## #*This notification is sent when all external data (for example image) has been downloaded.
## #
## #  This notification is sent when all external resources required by document
## #  have been completely downloaded. Sciter will send this notification
## #  asynchronously.
## #
## # obsolete #define SC_DOCUMENT_COMPLETE 0x03
## #   use DOCUMENT_COMPLETE DOM event.
## #
## #*This notification is sent on parsing the document and while processing
## #  elements having non empty style.behavior attribute value.
## #
## #  \param lParam #LPSCN_ATTACH_BEHAVIOR
## #
## #  Application has to provide implementation of #sciter::behavior interface.
## #  Set #SCN_ATTACH_BEHAVIOR::impl to address of this implementation.
## #

const
  SC_ATTACH_BEHAVIOR* = 0x00000004

## #*This notification is sent when instance of the engine is destroyed.
## #  It is always final notification.
## #
## #  \param lParam #LPSCN_ENGINE_DESTROYED
## #
## #

const
  SC_ENGINE_DESTROYED* = 0x00000005

## #*Posted notification.
## #
## #  \param lParam #LPSCN_POSTED_NOTIFICATION
## #
## #

const
  SC_POSTED_NOTIFICATION* = 0x00000006

## #*This notification is sent when the engine encounters critical rendering error: e.g. DirectX gfx driver error.
## #   Most probably bad gfx drivers.
## #
## #  \param lParam #LPSCN_GRAPHICS_CRITICAL_FAILURE
## #
## #

const
  SC_GRAPHICS_CRITICAL_FAILURE* = 0x00000007

## #*Notification callback structure.
## #

type
  SCITER_CALLBACK_NOTIFICATION* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.

  LPSCITER_CALLBACK_NOTIFICATION* = ptr SCITER_CALLBACK_NOTIFICATION
  SciterHostCallback* = proc (pns: LPSCITER_CALLBACK_NOTIFICATION;
                          callbackParam: pointer): uint32 {.cdecl.}
  LPSciterHostCallback* = ptr SciterHostCallback

## #*This structure is used by #SC_LOAD_DATA notification.
## # \copydoc SC_LOAD_DATA
## #

type
  SCN_LOAD_DATA* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    uri*: WideCString          ## #*< [in] Zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".
    outData*: pointer          ## #*< [in,out] pointer to loaded data to return. if data exists in the cache then this field contain pointer to it
    outDataSize*: uint32       ## #*< [in,out] loaded data size to return.
    dataType*: uint32          ## #*< [in] SciterResourceType
    requestId*: HREQUEST       ## #*< [in] request handle that can be used with sciter-x-request API
    principal*: HELEMENT
    initiator*: HELEMENT

  LPSCN_LOAD_DATA* = ptr SCN_LOAD_DATA

## #*This structure is used by #SC_DATA_LOADED notification.
## # \copydoc SC_DATA_LOADED
## #

type
  SCN_DATA_LOADED* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    uri*: WideCString          ## #*< [in] zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".
    data*: pointer             ## #*< [in] pointer to loaded data.
    dataSize*: uint32          ## #*< [in] loaded data size (in bytes).
    dataType*: uint32          ## #*< [in] SciterResourceType
    status*: uint32 ## #*< [in]
                  ## #                                         status = 0 (dataSize == 0) - unknown error.
                  ## #                                         status = 100..505 - http response status, Note: 200 - OK!
                  ## #                                         status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
                  ## #

  LPSCN_DATA_LOADED* = ptr SCN_DATA_LOADED

## #*This structure is used by #SC_ATTACH_BEHAVIOR notification.
## # \copydoc SC_ATTACH_BEHAVIOR *

type
  SCN_ATTACH_BEHAVIOR* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    element*: HELEMENT         ## #*< [in] target DOM element handle
    behaviorName*: cstring     ## #*< [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.
    elementProc*: ptr ElementEventProc ## #*< [out] pointer to ElementEventProc function.
    elementTag*: pointer       ## #*< [out] tag value, passed as is into pointer ElementEventProc function.

  LPSCN_ATTACH_BEHAVIOR* = ptr SCN_ATTACH_BEHAVIOR

## #*This structure is used by #SC_ENGINE_DESTROYED notification.
## # \copydoc SC_ENGINE_DESTROYED *

type
  SCN_ENGINE_DESTROYED* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.

  LPSCN_ENGINE_DESTROYED* = ptr SCN_ENGINE_DESTROYED

## #*This structure is used by #SC_ENGINE_DESTROYED notification.
## # \copydoc SC_ENGINE_DESTROYED *

type
  SCN_POSTED_NOTIFICATION* = object
    code*: uint32              ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    wparam*: uint32
    lparam*: uint32
    lreturn*: uint32

  LPSCN_POSTED_NOTIFICATION* = ptr SCN_POSTED_NOTIFICATION

## #*This structure is used by #SC_GRAPHICS_CRITICAL_FAILURE notification.
## # \copydoc SC_GRAPHICS_CRITICAL_FAILURE *

type
  SCN_GRAPHICS_CRITICAL_FAILURE* = object
    code*: uint32              ## #*< [in] = SC_GRAPHICS_CRITICAL_FAILURE
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.

  LPSCN_GRAPHICS_CRITICAL_FAILURE* = ptr SCN_GRAPHICS_CRITICAL_FAILURE
  SCRIPT_RUNTIME_FEATURES* = enum
    ALLOW_FILE_IO = 0x00000001, ALLOW_SOCKET_IO = 0x00000002, ALLOW_EVAL = 0x00000004,
    ALLOW_SYSINFO = 0x00000008


type
  GFX_LAYER* = enum
    GFX_LAYER_GDI = 1, GFX_LAYER_WARP = 2, GFX_LAYER_D2D = 3, GFX_LAYER_AUTO = 0x0000FFFF


type
  SCITER_RT_OPTIONS* = enum
    SCITER_SMOOTH_SCROLL = 1,   ## # value:TRUE - enable, value:FALSE - disable, enabled by default
    SCITER_CONNECTION_TIMEOUT = 2, ## # value: milliseconds, connection timeout of http client
    SCITER_HTTPS_ERROR = 3,     ## # value: 0 - drop connection, 1 - use builtin dialog, 2 - accept connection silently
    SCITER_FONT_SMOOTHING = 4,  ## # value: 0 - system default, 1 - no smoothing, 2 - std smoothing, 3 - clear type
    SCITER_TRANSPARENT_WINDOW = 6, ## # Windows Aero support, value:
                                ## # 0 - normal drawing,
                                ## # 1 - window has transparent background after calls DwmExtendFrameIntoClientArea() or DwmEnableBlurBehindWindow().
    SCITER_SET_GPU_BLACKLIST = 7, ## # hWnd = NULL,
                              ## # value = LPCBYTE, json - GPU black list, see: gpu-blacklist.json resource.
    SCITER_SET_SCRIPT_RUNTIME_FEATURES = 8, ## # value - combination of SCRIPT_RUNTIME_FEATURES flags.
    SCITER_SET_GFX_LAYER = 9,   ## # hWnd = NULL, value - GFX_LAYER
    SCITER_SET_DEBUG_MODE = 10, ## # hWnd, value - TRUE/FALSE
    SCITER_SET_UX_THEMING = 11, ## # hWnd = NULL, value - BOOL, TRUE - the engine will use "unisex" theme that is common for all platforms.
                            ## # That UX theme is not using OS primitives for rendering input elements. Use it if you want exactly
                            ## # the same (modulo fonts) look-n-feel on all platforms.
    SCITER_ALPHA_WINDOW = 12    ## #  hWnd, value - TRUE/FALSE - window uses per pixel alpha (e.g. WS_EX_LAYERED/UpdateLayeredWindow() window)


type
  URL_DATA* = object
    requestedUrl*: cstring     ## # requested URL
    realUrl*: cstring          ## # real URL data arrived from (after possible redirections)
    requestedType*: SciterResourceType ## # requested data category: html, script, image, etc.
    httpHeaders*: cstring      ## # if any
    mimeType*: cstring         ## # mime type reported by server (if any)
    encoding*: cstring         ## # data encoding (if any)
    data*: pointer
    dataLength*: uint32

  URL_DATA_RECEIVER* = proc (pUrlData: ptr URL_DATA; param: pointer) {.cdecl.}

when defined(osx):
  type
    SciterWindowDelegate* = pointer
  ## # Obj-C id, NSWindowDelegate and NSResponder
elif defined(windows):
  type
    SciterWindowDelegate* = proc (hwnd: HWINDOW; msg: uint32; wParam: WPARAM;
                              lParam: LPARAM; pParam: pointer; handled: ptr bool): LRESULT {.
        cdecl.}
elif defined(posix):
  type
    SciterWindowDelegate* = pointer
type
  SCITER_CREATE_WINDOW_FLAGS* = enum
    SW_CHILD = (1 shl 0),         ## # child window only, if this flag is set all other flags ignored
    SW_TITLEBAR = (1 shl 1),      ## # toplevel window, has titlebar
    SW_RESIZEABLE = (1 shl 2),    ## # has resizeable frame
    SW_TOOL = (1 shl 3),          ## # is tool window
    SW_CONTROLS = (1 shl 4),      ## # has minimize / maximize buttons
    SW_GLASSY = (1 shl 5),        ## # glassy window ( DwmExtendFrameIntoClientArea on windows )
    SW_ALPHA = (1 shl 6),         ## # transparent window ( e.g. WS_EX_LAYERED on Windows )
    SW_MAIN = (1 shl 7),          ## # main window of the app, will terminate the app on close
    SW_POPUP = (1 shl 8),         ## # the window is created as topmost window.
    SW_ENABLE_DEBUG = (1 shl 9),  ## # make this window inspector ready
    SW_OWNS_VM = (1 shl 10)       ## # it has its own script VM


## #* SciterSetupDebugOutput - setup debug output function.
## #
## #   This output function will be used for reprting problems
## #   found while loading html and css documents.
## #
## #

type
  OUTPUT_SUBSYTEMS* = enum
    OT_DOM = 0,                 ## # html parser & runtime
    OT_CSSS,                  ## # csss! parser & runtime
    OT_CSS,                   ## # css parser
    OT_TIS                    ## # TIS parser & runtime


type
  OUTPUT_SEVERITY* = enum
    OS_INFO, OS_WARNING, OS_ERROR


type
  DEBUG_OUTPUT_PROC* = proc (param: pointer; subsystem: uint32; ## #OUTPUT_SUBSYTEMS
                          severity: uint32; text: WideCString; text_length: uint32) {.
      cdecl.}
