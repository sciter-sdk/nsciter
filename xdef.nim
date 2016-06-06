## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## #  
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## #  
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## # 

import xtypes,xrequest,xdom
## #*Get name of Sciter window class.
## # 
## #  \return \b LPCWSTR, name of Sciter window class.
## #          \b NULL if initialization of the engine failed, Direct2D or DirectWrite are not supported on the OS.
## # 
## #  Use this function if you wish to create unicode version of Sciter.
## #  The returned name can be used in CreateWindow(Ex)W function.
## #  You can use #SciterClassNameT macro.
## # 

proc SciterClassName*(): ptr WideCString
## #*Returns major and minor version of Sciter engine.
## #   \return UINT, hiword (16-bit) contains major number and loword contains minor number;
## # 

proc SciterVersion*(major: bool): cuint
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
    code*: cuint               ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
  
  LPSCITER_CALLBACK_NOTIFICATION* = ptr SCITER_CALLBACK_NOTIFICATION
  SciterHostCallback* = proc (pns: LPSCITER_CALLBACK_NOTIFICATION;
                           callbackParam: pointer): cuint
  LPSciterHostCallback* = ptr SciterHostCallback

## #*This structure is used by #SC_LOAD_DATA notification.
## # \copydoc SC_LOAD_DATA
## # 

type
  SCN_LOAD_DATA* = object
    code*: cuint               ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    uri*: ptr WideCString       ## #*< [in] Zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".
    outData*: ptr byte          ## #*< [in,out] pointer to loaded data to return. if data exists in the cache then this field contain pointer to it
    outDataSize*: cuint        ## #*< [in,out] loaded data size to return.
    dataType*: cuint           ## #*< [in] SciterResourceType 
    requestId*: HREQUEST       ## #*< [in] request handle that can be used with sciter-x-request API 
    principal*: HELEMENT
    initiator*: HELEMENT

  LPSCN_LOAD_DATA* = ptr SCN_LOAD_DATA

## #*This structure is used by #SC_DATA_LOADED notification.
## # \copydoc SC_DATA_LOADED
## # 

type
  SCN_DATA_LOADED* = object
    code*: cuint               ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    uri*: ptr WideCString       ## #*< [in] zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".
    data*: ptr byte             ## #*< [in] pointer to loaded data.
    dataSize*: cuint           ## #*< [in] loaded data size (in bytes).
    dataType*: cuint           ## #*< [in] SciterResourceType 
    status*: cuint ## #*< [in]
                 ## #                                         status = 0 (dataSize == 0) - unknown error.
                 ## #                                         status = 100..505 - http response status, Note: 200 - OK!
                 ## #                                         status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
                 ## #                                 
  
  LPSCN_DATA_LOADED* = ptr SCN_DATA_LOADED

## #*This structure is used by #SC_ATTACH_BEHAVIOR notification.
## # \copydoc SC_ATTACH_BEHAVIOR *

type
  SCN_ATTACH_BEHAVIOR* = object
    code*: cuint               ## #*< [in] one of the codes above.
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
    code*: cuint               ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
  
  LPSCN_ENGINE_DESTROYED* = ptr SCN_ENGINE_DESTROYED

## #*This structure is used by #SC_ENGINE_DESTROYED notification.
## # \copydoc SC_ENGINE_DESTROYED *

type
  SCN_POSTED_NOTIFICATION* = object
    code*: cuint               ## #*< [in] one of the codes above.
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
    wparam*: csize
    lparam*: csize
    lreturn*: csize

  LPSCN_POSTED_NOTIFICATION* = ptr SCN_POSTED_NOTIFICATION

## #*This structure is used by #SC_GRAPHICS_CRITICAL_FAILURE notification.
## # \copydoc SC_GRAPHICS_CRITICAL_FAILURE *

type
  SCN_GRAPHICS_CRITICAL_FAILURE* = object
    code*: cuint               ## #*< [in] = SC_GRAPHICS_CRITICAL_FAILURE 
    hwnd*: HWINDOW             ## #*< [in] HWINDOW of the window this callback was attached to.
  
  LPSCN_GRAPHICS_CRITICAL_FAILURE* = ptr SCN_GRAPHICS_CRITICAL_FAILURE

## #*This function is used in response to SCN_LOAD_DATA request.
## # 
## #  \param[in] hwnd \b HWINDOW, Sciter window handle.
## #  \param[in] uri \b LPCWSTR, URI of the data requested by Sciter.
## #  \param[in] data \b LPBYTE, pointer to data buffer.
## #  \param[in] dataLength \b UINT, length of the data in bytes.
## #  \return \b BOOL, TRUE if Sciter accepts the data or \c FALSE if error occured
## #  (for example this function was called outside of #SCN_LOAD_DATA request).
## # 
## #  \warning If used, call of this function MUST be done ONLY while handling
## #  SCN_LOAD_DATA request and in the same thread. For asynchronous resource loading
## #  use SciterDataReadyAsync
## # 

proc SciterDataReady*(hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                     dataLength: cuint): bool
## #*Use this function outside of SCN_LOAD_DATA request. This function is needed when you
## #  you have your own http client implemented in your application.
## # 
## #  \param[in] hwnd \b HWINDOW, Sciter window handle.
## #  \param[in] uri \b LPCWSTR, URI of the data requested by Sciter.
## #  \param[in] data \b LPBYTE, pointer to data buffer.
## #  \param[in] dataLength \b UINT, length of the data in bytes.
## #  \param[in] requestId \b LPVOID, SCN_LOAD_DATA requestId, can ne NULL.
## #  \return \b BOOL, TRUE if Sciter accepts the data or \c FALSE if error occured
## # 

proc SciterDataReadyAsync*(hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                          dataLength: cuint; requestId: pointer): bool
when defined(windows):
  ## #*Sciter Window Proc.
  proc SciterProc*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM): LRESULT
  ## #*Sciter Window Proc without call of DefWindowProc.
  proc SciterProcND*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM;
                    pbHandled: ptr bool): LRESULT
## #*Load HTML file.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] filename \b LPCWSTR, File name of an HTML file.
## #  \return \b BOOL, \c TRUE if the text was parsed and loaded successfully, \c FALSE otherwise.
## # 

proc SciterLoadFile*(hWndSciter: HWINDOW; filename: ptr WideCString): bool
## #*Load HTML from in memory buffer with base.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] html \b LPCBYTE, Address of HTML to load.
## #  \param[in] htmlSize \b UINT, Length of the array pointed by html parameter.
## #  \param[in] baseUrl \b LPCWSTR, base URL. All relative links will be resolved against
## #                                 this URL.
## #  \return \b BOOL, \c TRUE if the text was parsed and loaded successfully, FALSE otherwise.
## # 

proc SciterLoadHtml*(hWndSciter: HWINDOW; html: ptr byte; htmlSize: cuint;
                    baseUrl: ptr WideCString): bool
## #*Set \link #SCITER_NOTIFY() notification callback function \endlink.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] cb \b SCITER_NOTIFY*, \link #SCITER_NOTIFY() callback function \endlink.
## #  \param[in] cbParam \b LPVOID, parameter that will be passed to \link #SCITER_NOTIFY() callback function \endlink as vParam paramter.
## # 

proc SciterSetCallback*(hWndSciter: HWINDOW; cb: LPSciterHostCallback;
                       cbParam: pointer)
## #*Set Master style sheet.
## # 
## #  \param[in] utf8 \b LPCBYTE, start of CSS buffer.
## #  \param[in] numBytes \b UINT, number of bytes in utf8.
## # 

proc SciterSetMasterCSS*(utf8: ptr byte; numBytes: cuint): bool
## #*Append Master style sheet.
## # 
## #  \param[in] utf8 \b LPCBYTE, start of CSS buffer.
## #  \param[in] numBytes \b UINT, number of bytes in utf8.
## # 
## # 

proc SciterAppendMasterCSS*(utf8: ptr byte; numBytes: cuint): bool
## #*Set (reset) style sheet of current document.
## # Will reset styles for all elements according to given CSS (utf8)
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] utf8 \b LPCBYTE, start of CSS buffer.
## #  \param[in] numBytes \b UINT, number of bytes in utf8.
## # 

proc SciterSetCSS*(hWndSciter: HWINDOW; utf8: ptr byte; numBytes: cuint;
                  baseUrl: ptr WideCString; mediaType: ptr WideCString): bool
## #*Set media type of this sciter instance.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] mediaType \b LPCWSTR, media type name.
## # 
## #  For example media type can be "handheld", "projection", "screen", "screen-hires", etc.
## #  By default sciter window has "screen" media type.
## # 
## #  Media type name is used while loading and parsing style sheets in the engine so
## #  you should call this function *before* loading document in it.
## # 
## # 

proc SciterSetMediaType*(hWndSciter: HWINDOW; mediaType: ptr WideCString): bool
## #*Set media variables of this sciter instance.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] mediaVars \b SCITER_VALUE, map that contains name/value pairs - media variables to be set.
## # 
## #  For example media type can be "handheld:true", "projection:true", "screen:true", etc.
## #  By default sciter window has "screen:true" and "desktop:true"/"handheld:true" media variables.
## # 
## #  Media variables can be changed in runtime. This will cause styles of the document to be reset.
## # 
## # 

proc SciterSetMediaVars*(hWndSciter: HWINDOW; mediaVars: ptr SCITER_VALUE): bool
proc SciterGetMinWidth*(hWndSciter: HWINDOW): cuint
proc SciterGetMinHeight*(hWndSciter: HWINDOW; width: cuint): cuint
proc SciterCall*(hWnd: HWINDOW; functionName: cstring; argc: cuint;
                argv: ptr SCITER_VALUE; retval: ptr SCITER_VALUE): bool
## # evalue script in context of current document

proc SciterEval*(hwnd: HWINDOW; script: ptr WideCString; scriptLength: cuint;
                pretval: ptr SCITER_VALUE): bool
## #*Update pending changes in Sciter window.
## # 
## #  \param[in] hwnd \b HWINDOW, Sciter window handle.
## # 
## # 

proc SciterUpdateWindow*(hwnd: HWINDOW)
## #* Try to translate message that sciter window is interested in.
## # 
## #  \param[in,out] lpMsg \b MSG*, address of message structure that was passed before to ::DispatchMessage(), ::PeekMessage().
## # 
## #  SciterTranslateMessage has the same meaning as ::TranslateMessage() and should be called immediately before it.
## #  Example:
## # 
## #    if( !SciterTranslateMessage(&msg) )
## #       TranslateMessage(&msg);
## # 
## #  ATTENTION!: SciterTranslateMessage call is critical for popup elements in MoSciter.
## #              On Desktop versions of the Sciter this function does nothing so can be ommited.
## # 
## # 

when defined(windows):
  proc SciterTranslateMessage*(lpMsg: ptr MSG): bool
## #*Set various options.
## # 
## #  \param[in] hWnd \b HWINDOW, Sciter window handle.
## #  \param[in] option \b UINT, id of the option, one of SCITER_RT_OPTIONS
## #  \param[in] option \b UINT, value of the option.
## # 
## # 

type
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


proc SciterSetOption*(hWnd: HWINDOW; option: cuint; value: csize): bool
## #*Get current pixels-per-inch metrics of the Sciter window
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[out] px \b PUINT, get ppi in horizontal direction.
## #  \param[out] py \b PUINT, get ppi in vertical direction.
## # 
## # 

proc SciterGetPPI*(hWndSciter: HWINDOW; px: ptr cuint; py: ptr cuint)
## #*Get "expando" of the view object
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[out] pval \b VALUE*, expando as sciter::value.
## # 
## # 

proc SciterGetViewExpando*(hwnd: HWINDOW; pval: ptr VALUE): bool
type
  URL_DATA* = object
    requestedUrl*: cstring     ## # requested URL
    realUrl*: cstring          ## # real URL data arrived from (after possible redirections)
    requestedType*: SciterResourceType ## # requested data category: html, script, image, etc.
    httpHeaders*: cstring      ## # if any
    mimeType*: cstring         ## # mime type reported by server (if any)
    encoding*: cstring         ## # data encoding (if any)
    data*: ptr byte
    dataLength*: cuint

  URL_DATA_RECEIVER* = proc (pUrlData: ptr URL_DATA; param: pointer)

## #* Get url resource data received by the engine
## #   Note: this function really works only if the engine is set to debug mode.
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] receiver \b URL_DATA_RECEIVER, address of reciver callback.
## #  \param[in] param \b LPVOID, param passed to callback as it is.
## #  \param[in] url \b LPCSTR, optional, url of the data. If not provided the engine will list all loaded resources
## #  \return \b BOOL, \c TRUE if receiver is called at least once, FALSE otherwise.
## # 
## # 

proc SciterEnumUrlData*(hWndSciter: HWINDOW; receiver: ptr URL_DATA_RECEIVER;
                       param: pointer; url: cstring): bool
when defined(windows):
  ## #*Creates instance of Sciter Engine on window controlled by DirectX
  ## #
  ## # \param[in] hwnd \b HWINDOW, window handle to create Sciter on.
  ## # \param[in] IDXGISwapChain \b pSwapChain,  reference of IDXGISwapChain created on the window.
  ## # \return \b BOOL, \c TRUE if engine instance is created, FALSE otherwise.
  ## #
  ## #
  proc SciterCreateOnDirectXWindow*(hwnd: HWINDOW; pSwapChain: ptr IDXGISwapChain): bool
  ## #*Renders content of the document loaded into the window
  ## # Optionally allows to render parts of document (separate DOM elements) as layers
  ## #
  ## # \param[in] hwnd \b HWINDOW, window handle to create Sciter on.
  ## # \param[in] HELEMENT \b elementToRenderOrNull,  html element to render. If NULL then the engine renders whole document.
  ## # \param[in] BOOL \b frontLayer,  TRUE if elementToRenderOrNull is not NULL and this is the topmost layer.
  ## # \return \b BOOL, \c TRUE if layer was rendered successfully.
  ## #
  ## #
  proc SciterRenderOnDirectXWindow*(hwnd: HWINDOW;
                                   elementToRenderOrNull: HELEMENT = nil;
                                   frontLayer: bool = FALSE): bool
  ## #*Renders content of the document loaded to DXGI texture
  ## # Optionally allows to render parts of document (separate DOM elements) as layers
  ## #
  ## # \param[in] HWINDOW \b hwnd, window handle to create Sciter on.
  ## # \param[in] HELEMENT \b elementToRenderOrNull,  html element to render. If NULL then the engine renders whole document.
  ## # \param[in] IDXGISurface \b surface, DirectX 2D texture to render in.
  ## # \return \b BOOL, \c TRUE if layer was rendered successfully.
  ## #
  ## #
  proc SciterRenderOnDirectXTexture*(hwnd: HWINDOW;
                                    elementToRenderOrNull: HELEMENT;
                                    surface: ptr IDXGISurface): bool
  ## #*Render document to ID2D1RenderTarget
  ## # 
  ## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
  ## #  \param[in] ID2D1RenderTarget \b prt, Direct2D render target.
  ## #  \return \b BOOL, \c TRUE if hBmp is 24bpp or 32bpp, FALSE otherwise.
  ## # 
  ## # 
  proc SciterRenderD2D*(hWndSciter: HWINDOW; prt: ptr ID2D1RenderTarget): bool
  ## #* Obtain pointer to ID2D1Factory instance used by the engine:
  ## # 
  ## #  \param[in] ID2D1Factory \b **ppf, address of variable receiving pointer of ID2D1Factory.
  ## #  \return \b BOOL, \c TRUE if parameters are valid and *ppf was set by valid pointer.
  ## # 
  ## #  NOTE 1: ID2D1Factory returned by the function is "add-refed" - it is your responsibility to call Release() on it.
  ## #  NOTE 2: *ppf variable shall be initialized to NULL before calling the function.
  ## # 
  ## # 
  proc SciterD2DFactory*(ppf: ptr ptr ID2D1Factory): bool
  ## #* Obtain pointer to IDWriteFactory instance used by the engine:
  ## # 
  ## #  \param[in] IDWriteFactory \b **ppf, address of variable receiving pointer of IDWriteFactory.
  ## #  \return \b BOOL, \c TRUE if parameters are valid and *ppf was set by valid pointer.
  ## # 
  ## #  NOTE 1: IDWriteFactory returned by the function is "add-refed" - it is your responsibility to call Release() on it.
  ## #  NOTE 2: *ppf variable shall be initialized to NULL before calling the function.
  ## # 
  ## # 
  proc SciterDWFactory*(ppf: ptr ptr IDWriteFactory): bool
## #* Get graphics capabilities of the system
## # 
## #  \pcaps[in] LPUINT \b pcaps, address of variable receiving:
## #                              0 - no compatible graphics found;
## #                              1 - compatible graphics found but Direct2D will use WARP driver (software emulation);
## #                              2 - Direct2D will use hardware backend (best performance);
## #  \return \b BOOL, \c TRUE if pcaps is valid pointer.
## # 
## # 

proc SciterGraphicsCaps*(pcaps: LPUINT): bool
## #* Set sciter home url.
## #   home url is used for resolving sciter: urls
## #   If you will set it like SciterSetHomeURL(hwnd,"http://sciter.com/modules/")
## #   then <script src="sciter:lib/root-extender.tis"> will load
## #   root-extender.tis from http://sciter.com/modules/lib/root-extender.tis
## # 
## #  \param[in] hWndSciter \b HWINDOW, Sciter window handle.
## #  \param[in] baseUrl \b LPCWSTR, URL of sciter home.
## # 
## # 

proc SciterSetHomeURL*(hWndSciter: HWINDOW; baseUrl: ptr WideCString): bool
when defined(osx):
  proc SciterCreateNSView*(frame: ptr Rect): HWINDOW
  ## # returns NSView*
  type
    SciterWindowDelegate* = pointer
  ## # Obj-C id, NSWindowDelegate and NSResponder
elif defined(windows):
  type
    SciterWindowDelegate* = proc (hwnd: HWINDOW; msg: cuint; wParam: WPARAM;
                               lParam: LPARAM; pParam: pointer; handled: ptr bool): LRESULT
elif defined(linux):
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


## #* Create sciter window.
## #   On Windows returns HWND of either top-level or child window created.
## #   On OS X returns NSView* of either top-level window or child view .
## # 
## #  \param[in] creationFlags \b SCITER_CREATE_WINDOW_FLAGS, creation flags.
## #  \param[in] frame \b LPRECT, window frame position and size.
## #  \param[in] delegate \b SciterWindowDelegate, either partial WinProc implementation or thing implementing NSWindowDelegate protocol.
## #  \param[in] delegateParam \b LPVOID, optional param passed to SciterWindowDelegate.
## #  \param[in] parent \b HWINDOW, optional parent window.
## # 
## # 

proc SciterCreateWindow*(creationFlags: cuint; frame: ptr Rect;
                        delegate: ptr SciterWindowDelegate; delegateParam: pointer;
                        parent: HWINDOW): HWINDOW
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
  DEBUG_OUTPUT_PROC* = proc (param: pointer; subsystem: cuint; ## #OUTPUT_SUBSYTEMS
                          severity: cuint; text: ptr WideCString; text_length: cuint)

proc SciterSetupDebugOutput*(hwndOrNull: HWINDOW; param: pointer; pfOutput: DEBUG_OUTPUT_PROC)
  ## # HWINDOW or null if this is global output handler
  ## # param to be passed "as is" to the pfOutput
  ## # output function, output stream alike thing.