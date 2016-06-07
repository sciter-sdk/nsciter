## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## # 
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## # 
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## # 

import xtypes,xdef,xrequest,xvalue,xdom,xtiscript,xgraphics
type
  SciterGraphicsAPI* = object
  
  ISciterAPI* = object
    version*: cuint            ## # is zero for now
    SciterClassName*: proc (): ptr WideCString
    SciterVersion*: proc (major: bool): cuint
    SciterDataReady*: proc (hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                          dataLength: cuint): bool
    SciterDataReadyAsync*: proc (hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                               dataLength: cuint; requestId: pointer): bool
    when defined(windows):
      SciterProc*: proc (hwnd: HWINDOW; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT
      SciterProcND*: proc (hwnd: HWINDOW; msg: UINT; wParam: WPARAM; lParam: LPARAM; pbHandled: ptr BOOL): LRESULT
    SciterLoadFile*: proc (hWndSciter: HWINDOW; filename: ptr WideCString): bool
    SciterLoadHtml*: proc (hWndSciter: HWINDOW; html: ptr byte; htmlSize: cuint;
                         baseUrl: ptr WideCString): bool
    SciterSetCallback*: proc (hWndSciter: HWINDOW; cb: LPSciterHostCallback;
                            cbParam: pointer)
    SciterSetMasterCSS*: proc (utf8: ptr byte; numBytes: cuint): bool
    SciterAppendMasterCSS*: proc (utf8: ptr byte; numBytes: cuint): bool
    SciterSetCSS*: proc (hWndSciter: HWINDOW; utf8: ptr byte; numBytes: cuint;
                       baseUrl: ptr WideCString; mediaType: ptr WideCString): bool
    SciterSetMediaType*: proc (hWndSciter: HWINDOW; mediaType: ptr WideCString): bool
    SciterSetMediaVars*: proc (hWndSciter: HWINDOW; mediaVars: ptr SCITER_VALUE): bool
    SciterGetMinWidth*: proc (hWndSciter: HWINDOW): cuint
    SciterGetMinHeight*: proc (hWndSciter: HWINDOW; width: cuint): cuint
    SciterCall*: proc (hWnd: HWINDOW; functionName: cstring; argc: cuint;
                     argv: ptr SCITER_VALUE; retval: ptr SCITER_VALUE): bool
    SciterEval*: proc (hwnd: HWINDOW; script: ptr WideCString; scriptLength: cuint;
                     pretval: ptr SCITER_VALUE): bool
    SciterUpdateWindow*: proc (hwnd: HWINDOW)
    when defined(windows):
      SciterTranslateMessage*: proc (lpMsg: ptr MSG): BOOL
    SciterSetOption*: proc (hWnd: HWINDOW; option: cuint; value: csize): bool
    SciterGetPPI*: proc (hWndSciter: HWINDOW; px: ptr cuint; py: ptr cuint)
    SciterGetViewExpando*: proc (hwnd: HWINDOW; pval: ptr VALUE): bool
    when defined(windows):
      SciterRenderD2D*: proc (hWndSciter:HWINDOW, tgt:ptr ID2D1RenderTarget): BOOL
      SciterD2DFactory*: proc (ppf:ptr ID2D1FactoryPtr): BOOL
      SciterDWFactory*: proc (ppf:ptr IDWriteFactoryPtr): BOOL
    SciterGraphicsCaps*: proc (pcaps: ptr cuint): bool
    SciterSetHomeURL*: proc (hWndSciter: HWINDOW; baseUrl: ptr WideCString): bool
    when defined(osx):
      SciterCreateNSView*: proc (frame:LPRECT): HWINDOW
    elif defined(linux):
      SciterCreateWidget*: proc (frame:ptr Rect): HWINDOW
    SciterCreateWindow*: proc (creationFlags: cuint; frame: ptr Rect;
                             delegate: ptr SciterWindowDelegate;
                             delegateParam: pointer; parent: HWINDOW): HWINDOW
    SciterSetupDebugOutput*: proc (hwndOrNull: HWINDOW; param: pointer; pfOutput: DEBUG_OUTPUT_PROC) ## #|
                                                                                             ## #| DOM Element API
                                                                                             ## #|
    ## # HWINDOW or null if this is global output handler
    ## # param to be passed "as is" to the pfOutput
    ## # output function, output stream alike thing.
    Sciter_UseElement*: proc (he: HELEMENT): cint
    Sciter_UnuseElement*: proc (he: HELEMENT): cint
    SciterGetRootElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint
    SciterGetFocusElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint
    SciterFindElement*: proc (hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): cint
    SciterGetChildrenCount*: proc (he: HELEMENT; count: ptr cuint): cint
    SciterGetNthChild*: proc (he: HELEMENT; n: cuint; phe: ptr HELEMENT): cint
    SciterGetParentElement*: proc (he: HELEMENT; p_parent_he: ptr HELEMENT): cint
    SciterGetElementHtmlCB*: proc (he: HELEMENT; outer: bool;
                                 rcv: ptr LPCBYTE_RECEIVER; rcv_param: pointer): cint
    SciterGetElementTextCB*: proc (he: HELEMENT; rcv: ptr LPCWSTR_RECEIVER;
                                 rcv_param: pointer): cint
    SciterSetElementText*: proc (he: HELEMENT; utf16: ptr WideCString; length: cuint): cint
    SciterGetAttributeCount*: proc (he: HELEMENT; p_count: ptr cuint): cint
    SciterGetNthAttributeNameCB*: proc (he: HELEMENT; n: cuint;
                                      rcv: ptr LPCSTR_RECEIVER; rcv_param: pointer): cint
    SciterGetNthAttributeValueCB*: proc (he: HELEMENT; n: cuint;
                                       rcv: ptr LPCWSTR_RECEIVER;
                                       rcv_param: pointer): cint
    SciterGetAttributeByNameCB*: proc (he: HELEMENT; name: cstring;
                                     rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint
    SciterSetAttributeByName*: proc (he: HELEMENT; name: cstring;
                                   value: ptr WideCString): cint
    SciterClearAttributes*: proc (he: HELEMENT): cint
    SciterGetElementIndex*: proc (he: HELEMENT; p_index: ptr cuint): cint
    SciterGetElementType*: proc (he: HELEMENT; p_type: cstringArray): cint
    SciterGetElementTypeCB*: proc (he: HELEMENT; rcv: ptr LPCSTR_RECEIVER;
                                 rcv_param: pointer): cint
    SciterGetStyleAttributeCB*: proc (he: HELEMENT; name: cstring;
                                    rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint
    SciterSetStyleAttribute*: proc (he: HELEMENT; name: cstring;
                                  value: ptr WideCString): cint
    SciterGetElementLocation*: proc (he: HELEMENT; p_location: ptr Rect; areas: cuint): cint ## #ELEMENT_AREAS
    SciterScrollToView*: proc (he: HELEMENT; SciterScrollFlags: cuint): cint
    SciterUpdateElement*: proc (he: HELEMENT; andForceRender: bool): cint
    SciterRefreshElementArea*: proc (he: HELEMENT; rc: Rect): cint
    SciterSetCapture*: proc (he: HELEMENT): cint
    SciterReleaseCapture*: proc (he: HELEMENT): cint
    SciterGetElementHwnd*: proc (he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): cint
    SciterCombineURL*: proc (he: HELEMENT; szUrlBuffer: ptr WideCString;
                           UrlBufferSize: cuint): cint
    SciterSelectElements*: proc (he: HELEMENT; CSS_selectors: cstring;
                               callback: ptr SciterElementCallback; param: pointer): cint
    SciterSelectElementsW*: proc (he: HELEMENT; CSS_selectors: ptr WideCString;
                                callback: ptr SciterElementCallback; param: pointer): cint
    SciterSelectParent*: proc (he: HELEMENT; selector: cstring; depth: cuint;
                             heFound: ptr HELEMENT): cint
    SciterSelectParentW*: proc (he: HELEMENT; selector: ptr WideCString; depth: cuint;
                              heFound: ptr HELEMENT): cint
    SciterSetElementHtml*: proc (he: HELEMENT; html: ptr byte; htmlLength: cuint;
                               where: cuint): cint
    SciterGetElementUID*: proc (he: HELEMENT; puid: ptr cuint): cint
    SciterGetElementByUID*: proc (hwnd: HWINDOW; uid: cuint; phe: ptr HELEMENT): cint
    SciterShowPopup*: proc (hePopup: HELEMENT; heAnchor: HELEMENT; placement: cuint): cint
    SciterShowPopupAt*: proc (hePopup: HELEMENT; pos: Point; animate: bool): cint
    SciterHidePopup*: proc (he: HELEMENT): cint
    SciterGetElementState*: proc (he: HELEMENT; pstateBits: ptr cuint): cint
    SciterSetElementState*: proc (he: HELEMENT; stateBitsToSet: cuint;
                                stateBitsToClear: cuint; updateView: bool): cint
    SciterCreateElement*: proc (tagname: cstring; textOrNull: ptr WideCString;
                              phe: ptr HELEMENT): cint ## #out
    SciterCloneElement*: proc (he: HELEMENT; phe: ptr HELEMENT): cint ## #out
    SciterInsertElement*: proc (he: HELEMENT; hparent: HELEMENT; index: cuint): cint
    SciterDetachElement*: proc (he: HELEMENT): cint
    SciterDeleteElement*: proc (he: HELEMENT): cint
    SciterSetTimer*: proc (he: HELEMENT; milliseconds: cuint; timer_id: csize): cint
    SciterDetachEventHandler*: proc (he: HELEMENT; pep: LPELEMENT_EVENT_PROC;
                                   tag: pointer): cint
    SciterAttachEventHandler*: proc (he: HELEMENT; pep: LPELEMENT_EVENT_PROC;
                                   tag: pointer): cint
    SciterWindowAttachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: LPELEMENT_EVENT_PROC; tag: pointer; subscription: cuint): cint
    SciterWindowDetachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: LPELEMENT_EVENT_PROC; tag: pointer): cint
    SciterSendEvent*: proc (he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                          reason: csize; handled: ptr bool): cint ## #out
    SciterPostEvent*: proc (he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                          reason: csize): cint
    SciterCallBehaviorMethod*: proc (he: HELEMENT; params: ptr METHOD_PARAMS): cint
    SciterRequestElementData*: proc (he: HELEMENT; url: ptr WideCString;
                                   dataType: cuint; initiator: HELEMENT): cint
    SciterHttpRequest*: proc (he: HELEMENT; url: ptr WideCString; dataType: cuint;
                            requestType: cuint; requestParams: ptr REQUEST_PARAM; nParams: cuint): cint ## 
                                                                                                ## # 
                                                                                                ## element 
                                                                                                ## to 
                                                                                                ## deliver 
                                                                                                ## data
                                                                                                ## 
                                                                                                ## # 
                                                                                                ## url
                                                                                                ## 
                                                                                                ## # 
                                                                                                ## data 
                                                                                                ## type, 
                                                                                                ## see 
                                                                                                ## SciterResourceType.
                                                                                                ## 
                                                                                                ## # 
                                                                                                ## one 
                                                                                                ## of 
                                                                                                ## REQUEST_TYPE 
                                                                                                ## values
                                                                                                ## 
                                                                                                ## # 
                                                                                                ## parameters
    ## # number of parameters
    SciterGetScrollInfo*: proc (he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                              contentSize: ptr Size): cint
    SciterSetScrollPos*: proc (he: HELEMENT; scrollPos: Point; smooth: bool): cint
    SciterGetElementIntrinsicWidths*: proc (he: HELEMENT; pMinWidth: ptr cint;
        pMaxWidth: ptr cint): cint
    SciterGetElementIntrinsicHeight*: proc (he: HELEMENT; forWidth: cint;
        pHeight: ptr cint): cint
    SciterIsElementVisible*: proc (he: HELEMENT; pVisible: ptr bool): cint
    SciterIsElementEnabled*: proc (he: HELEMENT; pEnabled: ptr bool): cint
    SciterSortElements*: proc (he: HELEMENT; firstIndex: cuint; lastIndex: cuint;
                             cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): cint
    SciterSwapElements*: proc (he1: HELEMENT; he2: HELEMENT): cint
    SciterTraverseUIEvent*: proc (evt: cuint; eventCtlStruct: pointer;
                                bOutProcessed: ptr bool): cint
    SciterCallScriptingMethod*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                    argc: cuint; retval: ptr VALUE): cint
    SciterCallScriptingFunction*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                      argc: cuint; retval: ptr VALUE): cint
    SciterEvalElementScript*: proc (he: HELEMENT; script: ptr WideCString;
                                  scriptLength: cuint; retval: ptr VALUE): cint
    SciterAttachHwndToElement*: proc (he: HELEMENT; hwnd: HWINDOW): cint
    SciterControlGetType*: proc (he: HELEMENT; pType: ptr cuint): cint ## #CTL_TYPE
    SciterGetValue*: proc (he: HELEMENT; pval: ptr VALUE): cint
    SciterSetValue*: proc (he: HELEMENT; pval: ptr VALUE): cint
    SciterGetExpando*: proc (he: HELEMENT; pval: ptr VALUE; forceCreation: bool): cint
    SciterGetObject*: proc (he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): cint
    SciterGetElementNamespace*: proc (he: HELEMENT; pval: ptr tiscript_value): cint
    SciterGetHighlightedElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint
    SciterSetHighlightedElement*: proc (hwnd: HWINDOW; he: HELEMENT): cint ## #|
                                                                    ## #| DOM Node API
                                                                    ## #|
    SciterNodeAddRef*: proc (hn: HNODE): cint
    SciterNodeRelease*: proc (hn: HNODE): cint
    SciterNodeCastFromElement*: proc (he: HELEMENT; phn: ptr HNODE): cint
    SciterNodeCastToElement*: proc (hn: HNODE; he: ptr HELEMENT): cint
    SciterNodeFirstChild*: proc (hn: HNODE; phn: ptr HNODE): cint
    SciterNodeLastChild*: proc (hn: HNODE; phn: ptr HNODE): cint
    SciterNodeNextSibling*: proc (hn: HNODE; phn: ptr HNODE): cint
    SciterNodePrevSibling*: proc (hn: HNODE; phn: ptr HNODE): cint
    SciterNodeParent*: proc (hnode: HNODE; pheParent: ptr HELEMENT): cint
    SciterNodeNthChild*: proc (hnode: HNODE; n: cuint; phn: ptr HNODE): cint
    SciterNodeChildrenCount*: proc (hnode: HNODE; pn: ptr cuint): cint
    SciterNodeType*: proc (hnode: HNODE; pNodeType: ptr cuint): cint ## #NODE_TYPE
    SciterNodeGetText*: proc (hnode: HNODE; rcv: ptr LPCWSTR_RECEIVER;
                            rcv_param: pointer): cint
    SciterNodeSetText*: proc (hnode: HNODE; text: ptr WideCString; textLength: cuint): cint
    SciterNodeInsert*: proc (hnode: HNODE; where: cuint; ## #NODE_INS_TARGET
                           what: HNODE): cint
    SciterNodeRemove*: proc (hnode: HNODE; finalize: bool): cint
    SciterCreateTextNode*: proc (text: ptr WideCString; textLength: cuint;
                               phnode: ptr HNODE): cint
    SciterCreateCommentNode*: proc (text: ptr WideCString; textLength: cuint;
                                  phnode: ptr HNODE): cint ## #|
                                                       ## #| Value API
                                                       ## #|
    ValueInit*: proc (pval: ptr VALUE): cuint
    ValueClear*: proc (pval: ptr VALUE): cuint
    ValueCompare*: proc (pval1: ptr VALUE; pval2: ptr VALUE): cuint
    ValueCopy*: proc (pdst: ptr VALUE; psrc: ptr VALUE): cuint
    ValueIsolate*: proc (pdst: ptr VALUE): cuint
    ValueType*: proc (pval: ptr VALUE; pType: ptr cuint; pUnits: ptr cuint): cuint
    ValueStringData*: proc (pval: ptr VALUE; pChars: ptr ptr WideCString;
                          pNumChars: ptr cuint): cuint
    ValueStringDataSet*: proc (pval: ptr VALUE; chars: ptr WideCString; numChars: cuint;
                             units: cuint): cuint
    ValueIntData*: proc (pval: ptr VALUE; pData: ptr cint): cuint
    ValueIntDataSet*: proc (pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint
    ValueInt64Data*: proc (pval: ptr VALUE; pData: ptr cint): cuint
    ValueInt64DataSet*: proc (pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint
    ValueFloatData*: proc (pval: ptr VALUE; pData: ptr FLOAT_VALUE): cuint
    ValueFloatDataSet*: proc (pval: ptr VALUE; data: FLOAT_VALUE; `type`: cuint;
                            units: cuint): cuint
    ValueBinaryData*: proc (pval: ptr VALUE; pBytes: ptr ptr byte; pnBytes: ptr cuint): cuint
    ValueBinaryDataSet*: proc (pval: ptr VALUE; pBytes: ptr byte; nBytes: cuint;
                             `type`: cuint; units: cuint): cuint
    ValueElementsCount*: proc (pval: ptr VALUE; pn: ptr cint): cuint
    ValueNthElementValue*: proc (pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint
    ValueNthElementValueSet*: proc (pval: ptr VALUE; n: cint; pval_to_set: ptr VALUE): cuint
    ValueNthElementKey*: proc (pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint
    ValueEnumElements*: proc (pval: ptr VALUE; penum: ptr KeyValueCallback;
                            param: pointer): cuint
    ValueSetValueToKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): cuint
    ValueGetValueOfKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): cuint
    ValueToString*: proc (pval: ptr VALUE; how: cuint): cuint ## #VALUE_STRING_CVT_TYPE
    ValueFromString*: proc (pval: ptr VALUE; str: ptr WideCString; strLength: cuint;
                          how: cuint): cuint ## #VALUE_STRING_CVT_TYPE
    ValueInvoke*: proc (pval: ptr VALUE; pthis: ptr VALUE; argc: cuint; argv: ptr VALUE;
                      pretval: ptr VALUE; url: ptr WideCString): cuint
    ValueNativeFunctorSet*: proc (pval: ptr VALUE;
                                pinvoke: ptr NATIVE_FUNCTOR_INVOKE;
                                prelease: ptr NATIVE_FUNCTOR_RELEASE; tag: pointer): cuint
    ValueIsNativeFunctor*: proc (pval: ptr VALUE): bool ## # tiscript VM API
    TIScriptAPI*: proc (): ptr tiscript_native_interface
    SciterGetVM*: proc (hwnd: HWINDOW): HVM
    Sciter_tv2V*: proc (vm: HVM; script_value: tiscript_value; value: ptr VALUE;
                      isolate: bool): bool
    Sciter_V2tv*: proc (vm: HVM; valuev: ptr VALUE; script_value: ptr tiscript_value): bool
    SciterOpenArchive*: proc (archiveData: ptr byte; archiveDataLength: cuint): HSARCHIVE
    SciterGetArchiveItem*: proc (harc: HSARCHIVE; path: ptr WideCString;
                               pdata: ptr ptr byte; pdataLength: ptr cuint): bool
    SciterCloseArchive*: proc (harc: HSARCHIVE): bool
    SciterFireEvent*: proc (evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool;
                          handled: ptr bool): cint
    SciterGetCallbackParam*: proc (hwnd: HWINDOW): pointer
    SciterPostCallback*: proc (hwnd: HWINDOW; wparam: csize; lparam: csize;
                             timeoutms: cuint): csize
    GetSciterGraphicsAPI*: proc (): LPSciterGraphicsAPI
    GetSciterRequestAPI*: proc (): LPSciterRequestAPI
    when defined(windows):
      SciterCreateOnDirectXWindow*: proc (hwnd:HWINDOW, pSwapChain:ptr IDXGISwapChain): BOOL
      SciterRenderOnDirectXWindow*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, frontLayer:BOOL): BOOL
      SciterRenderOnDirectXTexture*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, surface:ptr IDXGISurface): BOOL
    for_c2nim_only_very_bad_patch_so_do_not_pay_attention_to_this_field*: nil ## # 
                                                                            ## c2nim 
                                                                            ## needs this :(
  

import dynlib

proc SAPI*():ptr ISciterAPI  {.inline.} =
  var libhandle = loadLib(SCITER_DLL_NAME)
  var procPtr = symAddr(libhandle, "SciterAPI")
  return cast[ptr ISciterAPI](procPtr)
  
proc gapi*():LPSciterGraphicsAPI {.inline.} =
  return SAPI().GetSciterGraphicsAPI()
  
proc rapi*():LPSciterRequestAPI {.inline.} =
  return SAPI().GetSciterRequestAPI()

## # defining "official" API functions:

proc SciterClassName*(): ptr WideCString {.inline.} =
  return SAPI().SciterClassName()

proc SciterVersion*(major: bool): cuint {.inline.} =
  return SAPI().SciterVersion(major)

proc SciterDataReady*(hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                     dataLength: cuint): bool {.inline.} =
  return SAPI().SciterDataReady(hwnd, uri, data, dataLength)

proc SciterDataReadyAsync*(hwnd: HWINDOW; uri: ptr WideCString; data: ptr byte;
                          dataLength: cuint; requestId: pointer): bool {.inline.} =
  return SAPI().SciterDataReadyAsync(hwnd, uri, data, dataLength, requestId)

when defined(windows):
  proc SciterProc*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM): LRESULT {.
      inline.} =
    return SAPI().SciterProc(hwnd, msg, wParam, lParam)

  proc SciterProcND*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM;
                    pbHandled: ptr bool): LRESULT {.inline.} =
    return SAPI().SciterProcND(hwnd, msg, wParam, lParam, pbHandled)

proc SciterLoadFile*(hWndSciter: HWINDOW; filename: ptr WideCString): bool {.inline.} =
  return SAPI().SciterLoadFile(hWndSciter, filename)

proc SciterLoadHtml*(hWndSciter: HWINDOW; html: ptr byte; htmlSize: cuint;
                    baseUrl: ptr WideCString): bool {.inline.} =
  return SAPI().SciterLoadHtml(hWndSciter, html, htmlSize, baseUrl)

proc SciterSetCallback*(hWndSciter: HWINDOW; cb: LPSciterHostCallback;
                       cbParam: pointer) {.inline.} =
  SAPI().SciterSetCallback(hWndSciter, cb, cbParam)

proc SciterSetMasterCSS*(utf8: ptr byte; numBytes: cuint): bool {.inline.} =
  return SAPI().SciterSetMasterCSS(utf8, numBytes)

proc SciterAppendMasterCSS*(utf8: ptr byte; numBytes: cuint): bool {.inline.} =
  return SAPI().SciterAppendMasterCSS(utf8, numBytes)

proc SciterSetCSS*(hWndSciter: HWINDOW; utf8: ptr byte; numBytes: cuint;
                  baseUrl: ptr WideCString; mediaType: ptr WideCString): bool {.inline.} =
  return SAPI().SciterSetCSS(hWndSciter, utf8, numBytes, baseUrl, mediaType)

proc SciterSetMediaType*(hWndSciter: HWINDOW; mediaType: ptr WideCString): bool {.
    inline.} =
  return SAPI().SciterSetMediaType(hWndSciter, mediaType)

proc SciterSetMediaVars*(hWndSciter: HWINDOW; mediaVars: ptr SCITER_VALUE): bool {.
    inline.} =
  return SAPI().SciterSetMediaVars(hWndSciter, mediaVars)

proc SciterGetMinWidth*(hWndSciter: HWINDOW): cuint {.inline.} =
  return SAPI().SciterGetMinWidth(hWndSciter)

proc SciterGetMinHeight*(hWndSciter: HWINDOW; width: cuint): cuint {.inline.} =
  return SAPI().SciterGetMinHeight(hWndSciter, width)

proc SciterCall*(hWnd: HWINDOW; functionName: cstring; argc: cuint;
                argv: ptr SCITER_VALUE; retval: ptr SCITER_VALUE): bool {.inline.} =
  return SAPI().SciterCall(hWnd, functionName, argc, argv, retval)

proc SciterEval*(hwnd: HWINDOW; script: ptr WideCString; scriptLength: cuint;
                pretval: ptr SCITER_VALUE): bool {.inline.} =
  return SAPI().SciterEval(hwnd, script, scriptLength, pretval)

proc SciterUpdateWindow*(hwnd: HWINDOW) {.inline.} =
  SAPI().SciterUpdateWindow(hwnd)

when defined(windows):
  proc SciterTranslateMessage*(lpMsg: ptr MSG): bool {.inline.} =
    return SAPI().SciterTranslateMessage(lpMsg)

proc SciterSetOption*(hWnd: HWINDOW; option: cuint; value: csize): bool {.inline.} =
  return SAPI().SciterSetOption(hWnd, option, value)

proc SciterGetPPI*(hWndSciter: HWINDOW; px: ptr cuint; py: ptr cuint) {.inline.} =
  SAPI().SciterGetPPI(hWndSciter, px, py)

proc SciterGetViewExpando*(hwnd: HWINDOW; pval: ptr VALUE): bool {.inline.} =
  return SAPI().SciterGetViewExpando(hwnd, pval)

when defined(windows):
  proc SciterRenderD2D*(hWndSciter: HWINDOW; prt: ptr ID2D1RenderTarget): bool {.inline.} =
    return SAPI().SciterRenderD2D(hWndSciter, prt)

  proc SciterD2DFactory*(ppf: ptr ptr ID2D1Factory): bool {.inline.} =
    return SAPI().SciterD2DFactory(ppf)

  proc SciterDWFactory*(ppf: ptr ptr IDWriteFactory): bool {.inline.} =
    return SAPI().SciterDWFactory(ppf)

proc SciterGraphicsCaps*(pcaps: ptr cuint): bool {.inline.} =
  return SAPI().SciterGraphicsCaps(pcaps)

proc SciterSetHomeURL*(hWndSciter: HWINDOW; baseUrl: ptr WideCString): bool {.inline.} =
  return SAPI().SciterSetHomeURL(hWndSciter, baseUrl)

when defined(osx):
  proc SciterCreateNSView*(frame: ptr Rect): HWINDOW {.inline.} =
    return SAPI().SciterCreateNSView(frame)

proc SciterCreateWindow*(creationFlags: cuint; frame: ptr Rect;
                        delegate: ptr SciterWindowDelegate; delegateParam: pointer;
                        parent: HWINDOW): HWINDOW {.inline.} =
  return SAPI().SciterCreateWindow(creationFlags, frame, delegate, delegateParam,
                                  parent)

proc Sciter_UseElement*(he: HELEMENT): cint {.inline.} =
  return SAPI().Sciter_UseElement(he)

proc Sciter_UnuseElement*(he: HELEMENT): cint {.inline.} =
  return SAPI().Sciter_UnuseElement(he)

proc SciterGetRootElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetRootElement(hwnd, phe)

proc SciterGetFocusElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetFocusElement(hwnd, phe)

proc SciterFindElement*(hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterFindElement(hwnd, pt, phe)

proc SciterGetChildrenCount*(he: HELEMENT; count: ptr cuint): cint {.inline.} =
  return SAPI().SciterGetChildrenCount(he, count)

proc SciterGetNthChild*(he: HELEMENT; n: cuint; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetNthChild(he, n, phe)

proc SciterGetParentElement*(he: HELEMENT; p_parent_he: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetParentElement(he, p_parent_he)

proc SciterGetElementHtmlCB*(he: HELEMENT; outer: bool; rcv: ptr LPCBYTE_RECEIVER;
                            rcv_param: pointer): cint {.inline.} =
  return SAPI().SciterGetElementHtmlCB(he, outer, rcv, rcv_param)

proc SciterGetElementTextCB*(he: HELEMENT; rcv: ptr LPCWSTR_RECEIVER;
                            rcv_param: pointer): cint {.inline.} =
  return SAPI().SciterGetElementTextCB(he, rcv, rcv_param)

proc SciterSetElementText*(he: HELEMENT; utf16: ptr WideCString; length: cuint): cint {.
    inline.} =
  return SAPI().SciterSetElementText(he, utf16, length)

proc SciterGetAttributeCount*(he: HELEMENT; p_count: ptr cuint): cint {.inline.} =
  return SAPI().SciterGetAttributeCount(he, p_count)

proc SciterGetNthAttributeNameCB*(he: HELEMENT; n: cuint; rcv: ptr LPCSTR_RECEIVER;
                                 rcv_param: pointer): cint {.inline.} =
  return SAPI().SciterGetNthAttributeNameCB(he, n, rcv, rcv_param)

proc SciterGetNthAttributeValueCB*(he: HELEMENT; n: cuint; rcv: ptr LPCWSTR_RECEIVER;
                                  rcv_param: pointer): cint {.inline.} =
  return SAPI().SciterGetNthAttributeValueCB(he, n, rcv, rcv_param)

proc SciterGetAttributeByNameCB*(he: HELEMENT; name: cstring;
                                rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline.} =
  return SAPI().SciterGetAttributeByNameCB(he, name, rcv, rcv_param)

proc SciterSetAttributeByName*(he: HELEMENT; name: cstring; value: ptr WideCString): cint {.
    inline.} =
  return SAPI().SciterSetAttributeByName(he, name, value)

proc SciterClearAttributes*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterClearAttributes(he)

proc SciterGetElementIndex*(he: HELEMENT; p_index: ptr cuint): cint {.inline.} =
  return SAPI().SciterGetElementIndex(he, p_index)

proc SciterGetElementType*(he: HELEMENT; p_type: cstringArray): cint {.inline.} =
  return SAPI().SciterGetElementType(he, p_type)

proc SciterGetElementTypeCB*(he: HELEMENT; rcv: ptr LPCSTR_RECEIVER;
                            rcv_param: pointer): cint {.inline.} =
  return SAPI().SciterGetElementTypeCB(he, rcv, rcv_param)

proc SciterGetStyleAttributeCB*(he: HELEMENT; name: cstring;
                               rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline.} =
  return SAPI().SciterGetStyleAttributeCB(he, name, rcv, rcv_param)

proc SciterSetStyleAttribute*(he: HELEMENT; name: cstring; value: ptr WideCString): cint {.
    inline.} =
  return SAPI().SciterSetStyleAttribute(he, name, value)

proc SciterGetElementLocation*(he: HELEMENT; p_location: ptr Rect; areas: cuint): cint {.
    inline.} =
  ## #ELEMENT_AREAS
  return SAPI().SciterGetElementLocation(he, p_location, areas)

proc SciterScrollToView*(he: HELEMENT; SciterScrollFlags: cuint): cint {.inline.} =
  return SAPI().SciterScrollToView(he, SciterScrollFlags)

proc SciterUpdateElement*(he: HELEMENT; andForceRender: bool): cint {.inline.} =
  return SAPI().SciterUpdateElement(he, andForceRender)

proc SciterRefreshElementArea*(he: HELEMENT; rc: Rect): cint {.inline.} =
  return SAPI().SciterRefreshElementArea(he, rc)

proc SciterSetCapture*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterSetCapture(he)

proc SciterReleaseCapture*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterReleaseCapture(he)

proc SciterGetElementHwnd*(he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): cint {.
    inline.} =
  return SAPI().SciterGetElementHwnd(he, p_hwnd, rootWindow)

proc SciterCombineURL*(he: HELEMENT; szUrlBuffer: ptr WideCString;
                      UrlBufferSize: cuint): cint {.inline.} =
  return SAPI().SciterCombineURL(he, szUrlBuffer, UrlBufferSize)

proc SciterSelectElements*(he: HELEMENT; CSS_selectors: cstring;
                          callback: ptr SciterElementCallback; param: pointer): cint {.
    inline.} =
  return SAPI().SciterSelectElements(he, CSS_selectors, callback, param)

proc SciterSelectElementsW*(he: HELEMENT; CSS_selectors: ptr WideCString;
                           callback: ptr SciterElementCallback; param: pointer): cint {.
    inline.} =
  return SAPI().SciterSelectElementsW(he, CSS_selectors, callback, param)

proc SciterSelectParent*(he: HELEMENT; selector: cstring; depth: cuint;
                        heFound: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterSelectParent(he, selector, depth, heFound)

proc SciterSelectParentW*(he: HELEMENT; selector: ptr WideCString; depth: cuint;
                         heFound: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterSelectParentW(he, selector, depth, heFound)

proc SciterSetElementHtml*(he: HELEMENT; html: ptr byte; htmlLength: cuint; where: cuint): cint {.
    inline.} =
  return SAPI().SciterSetElementHtml(he, html, htmlLength, where)

proc SciterGetElementUID*(he: HELEMENT; puid: ptr cuint): cint {.inline.} =
  return SAPI().SciterGetElementUID(he, puid)

proc SciterGetElementByUID*(hwnd: HWINDOW; uid: cuint; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetElementByUID(hwnd, uid, phe)

proc SciterShowPopup*(hePopup: HELEMENT; heAnchor: HELEMENT; placement: cuint): cint {.
    inline.} =
  return SAPI().SciterShowPopup(hePopup, heAnchor, placement)

proc SciterShowPopupAt*(hePopup: HELEMENT; pos: Point; animate: bool): cint {.inline.} =
  return SAPI().SciterShowPopupAt(hePopup, pos, animate)

proc SciterHidePopup*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterHidePopup(he)

proc SciterGetElementState*(he: HELEMENT; pstateBits: ptr cuint): cint {.inline.} =
  return SAPI().SciterGetElementState(he, pstateBits)

proc SciterSetElementState*(he: HELEMENT; stateBitsToSet: cuint;
                           stateBitsToClear: cuint; updateView: bool): cint {.inline.} =
  return SAPI().SciterSetElementState(he, stateBitsToSet, stateBitsToClear,
                                     updateView)

proc SciterCreateElement*(tagname: cstring; textOrNull: ptr WideCString;
                         phe: ptr HELEMENT): cint {.inline.} =
  ## #out
  return SAPI().SciterCreateElement(tagname, textOrNull, phe)

proc SciterCloneElement*(he: HELEMENT; phe: ptr HELEMENT): cint {.inline.} =
  ## #out
  return SAPI().SciterCloneElement(he, phe)

proc SciterInsertElement*(he: HELEMENT; hparent: HELEMENT; index: cuint): cint {.inline.} =
  return SAPI().SciterInsertElement(he, hparent, index)

proc SciterDetachElement*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterDetachElement(he)

proc SciterDeleteElement*(he: HELEMENT): cint {.inline.} =
  return SAPI().SciterDeleteElement(he)

proc SciterSetTimer*(he: HELEMENT; milliseconds: cuint; timer_id: csize): cint {.inline.} =
  return SAPI().SciterSetTimer(he, milliseconds, timer_id)

proc SciterDetachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline.} =
  return SAPI().SciterDetachEventHandler(he, pep, tag)

proc SciterAttachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline.} =
  return SAPI().SciterAttachEventHandler(he, pep, tag)

proc SciterWindowAttachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer;
                                    subscription: cuint): cint {.inline.} =
  return SAPI().SciterWindowAttachEventHandler(hwndLayout, pep, tag, subscription)

proc SciterWindowDetachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline.} =
  return SAPI().SciterWindowDetachEventHandler(hwndLayout, pep, tag)

proc SciterSendEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint; handled: ptr bool): cint {.inline.} =
  ## #out
  return SAPI().SciterSendEvent(he, appEventCode, heSource, reason, handled)

proc SciterPostEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint): cint {.inline.} =
  return SAPI().SciterPostEvent(he, appEventCode, heSource, reason)

proc SciterFireEvent*(evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool; handled: ptr bool): cint {.
    inline.} =
  return SAPI().SciterFireEvent(evt, post, handled)

proc SciterCallBehaviorMethod*(he: HELEMENT; params: ptr METHOD_PARAMS): cint {.inline.} =
  return SAPI().SciterCallBehaviorMethod(he, params)

proc SciterRequestElementData*(he: HELEMENT; url: ptr WideCString; dataType: cuint;
                              initiator: HELEMENT): cint {.inline.} =
  return SAPI().SciterRequestElementData(he, url, dataType, initiator)

proc SciterHttpRequest*(he: HELEMENT; url: ptr WideCString; dataType: cuint;
                       requestType: cuint; requestParams: ptr REQUEST_PARAM;
                       nParams: cuint): cint {.inline.} =
  return SAPI().SciterHttpRequest(he, url, dataType, requestType, requestParams,
                                 nParams)

proc SciterGetScrollInfo*(he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                         contentSize: ptr Size): cint {.inline.} =
  return SAPI().SciterGetScrollInfo(he, scrollPos, viewRect, contentSize)

proc SciterSetScrollPos*(he: HELEMENT; scrollPos: Point; smooth: bool): cint {.inline.} =
  return SAPI().SciterSetScrollPos(he, scrollPos, smooth)

proc SciterGetElementIntrinsicWidths*(he: HELEMENT; pMinWidth: ptr cint;
                                     pMaxWidth: ptr cint): cint {.inline.} =
  return SAPI().SciterGetElementIntrinsicWidths(he, pMinWidth, pMaxWidth)

proc SciterGetElementIntrinsicHeight*(he: HELEMENT; forWidth: cint; pHeight: ptr cint): cint {.
    inline.} =
  return SAPI().SciterGetElementIntrinsicHeight(he, forWidth, pHeight)

proc SciterIsElementVisible*(he: HELEMENT; pVisible: ptr bool): cint {.inline.} =
  return SAPI().SciterIsElementVisible(he, pVisible)

proc SciterIsElementEnabled*(he: HELEMENT; pEnabled: ptr bool): cint {.inline.} =
  return SAPI().SciterIsElementEnabled(he, pEnabled)

proc SciterSortElements*(he: HELEMENT; firstIndex: cuint; lastIndex: cuint;
                        cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): cint {.
    inline.} =
  return SAPI().SciterSortElements(he, firstIndex, lastIndex, cmpFunc, cmpFuncParam)

proc SciterSwapElements*(he1: HELEMENT; he2: HELEMENT): cint {.inline.} =
  return SAPI().SciterSwapElements(he1, he2)

proc SciterTraverseUIEvent*(evt: cuint; eventCtlStruct: pointer;
                           bOutProcessed: ptr bool): cint {.inline.} =
  return SAPI().SciterTraverseUIEvent(evt, eventCtlStruct, bOutProcessed)

proc SciterCallScriptingMethod*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                               argc: cuint; retval: ptr VALUE): cint {.inline.} =
  return SAPI().SciterCallScriptingMethod(he, name, argv, argc, retval)

proc SciterCallScriptingFunction*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                                 argc: cuint; retval: ptr VALUE): cint {.inline.} =
  return SAPI().SciterCallScriptingFunction(he, name, argv, argc, retval)

proc SciterEvalElementScript*(he: HELEMENT; script: ptr WideCString;
                             scriptLength: cuint; retval: ptr VALUE): cint {.inline.} =
  return SAPI().SciterEvalElementScript(he, script, scriptLength, retval)

proc SciterAttachHwndToElement*(he: HELEMENT; hwnd: HWINDOW): cint {.inline.} =
  return SAPI().SciterAttachHwndToElement(he, hwnd)

proc SciterControlGetType*(he: HELEMENT; pType: ptr cuint): cint {.inline.} =
  ## #CTL_TYPE
  return SAPI().SciterControlGetType(he, pType)

proc SciterGetValue*(he: HELEMENT; pval: ptr VALUE): cint {.inline.} =
  return SAPI().SciterGetValue(he, pval)

proc SciterSetValue*(he: HELEMENT; pval: ptr VALUE): cint {.inline.} =
  return SAPI().SciterSetValue(he, pval)

proc SciterGetExpando*(he: HELEMENT; pval: ptr VALUE; forceCreation: bool): cint {.inline.} =
  return SAPI().SciterGetExpando(he, pval, forceCreation)

proc SciterGetObject*(he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): cint {.
    inline.} =
  return SAPI().SciterGetObject(he, pval, forceCreation)

proc SciterGetElementNamespace*(he: HELEMENT; pval: ptr tiscript_value): cint {.inline.} =
  return SAPI().SciterGetElementNamespace(he, pval)

proc SciterGetHighlightedElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterGetHighlightedElement(hwnd, phe)

proc SciterSetHighlightedElement*(hwnd: HWINDOW; he: HELEMENT): cint {.inline.} =
  return SAPI().SciterSetHighlightedElement(hwnd, he)

proc SciterNodeAddRef*(hn: HNODE): cint {.inline.} =
  return SAPI().SciterNodeAddRef(hn)

proc SciterNodeRelease*(hn: HNODE): cint {.inline.} =
  return SAPI().SciterNodeRelease(hn)

proc SciterNodeCastFromElement*(he: HELEMENT; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodeCastFromElement(he, phn)

proc SciterNodeCastToElement*(hn: HNODE; he: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterNodeCastToElement(hn, he)

proc SciterNodeFirstChild*(hn: HNODE; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodeFirstChild(hn, phn)

proc SciterNodeLastChild*(hn: HNODE; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodeLastChild(hn, phn)

proc SciterNodeNextSibling*(hn: HNODE; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodeNextSibling(hn, phn)

proc SciterNodePrevSibling*(hn: HNODE; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodePrevSibling(hn, phn)

proc SciterNodeParent*(hnode: HNODE; pheParent: ptr HELEMENT): cint {.inline.} =
  return SAPI().SciterNodeParent(hnode, pheParent)

proc SciterNodeNthChild*(hnode: HNODE; n: cuint; phn: ptr HNODE): cint {.inline.} =
  return SAPI().SciterNodeNthChild(hnode, n, phn)

proc SciterNodeChildrenCount*(hnode: HNODE; pn: ptr cuint): cint {.inline.} =
  return SAPI().SciterNodeChildrenCount(hnode, pn)

proc SciterNodeType*(hnode: HNODE; pNodeType: ptr cuint): cint {.inline.} =
  ## #NODE_TYPE
  return SAPI().SciterNodeType(hnode, pNodeType)

proc SciterNodeGetText*(hnode: HNODE; rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline.} =
  return SAPI().SciterNodeGetText(hnode, rcv, rcv_param)

proc SciterNodeSetText*(hnode: HNODE; text: ptr WideCString; textLength: cuint): cint {.
    inline.} =
  return SAPI().SciterNodeSetText(hnode, text, textLength)

proc SciterNodeInsert*(hnode: HNODE; where: cuint; ## #NODE_INS_TARGET
                      what: HNODE): cint {.inline.} =
  return SAPI().SciterNodeInsert(hnode, where, what)

proc SciterNodeRemove*(hnode: HNODE; finalize: bool): cint {.inline.} =
  return SAPI().SciterNodeRemove(hnode, finalize)

proc SciterCreateTextNode*(text: ptr WideCString; textLength: cuint; phnode: ptr HNODE): cint {.
    inline.} =
  return SAPI().SciterCreateTextNode(text, textLength, phnode)

proc SciterCreateCommentNode*(text: ptr WideCString; textLength: cuint;
                             phnode: ptr HNODE): cint {.inline.} =
  return SAPI().SciterCreateCommentNode(text, textLength, phnode)

proc SciterGetVM*(hwnd: HWINDOW): HVM {.inline.} =
  return SAPI().SciterGetVM(hwnd)

proc ValueInit*(pval: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueInit(pval)

proc ValueClear*(pval: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueClear(pval)

proc ValueCompare*(pval1: ptr VALUE; pval2: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueCompare(pval1, pval2)

proc ValueCopy*(pdst: ptr VALUE; psrc: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueCopy(pdst, psrc)

proc ValueIsolate*(pdst: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueIsolate(pdst)

proc ValueType*(pval: ptr VALUE; pType: ptr cuint; pUnits: ptr cuint): cuint {.inline.} =
  return SAPI().ValueType(pval, pType, pUnits)

proc ValueStringData*(pval: ptr VALUE; pChars: ptr ptr WideCString; pNumChars: ptr cuint): cuint {.
    inline.} =
  return SAPI().ValueStringData(pval, pChars, pNumChars)

proc ValueStringDataSet*(pval: ptr VALUE; chars: ptr WideCString; numChars: cuint;
                        units: cuint): cuint {.inline.} =
  return SAPI().ValueStringDataSet(pval, chars, numChars, units)

proc ValueIntData*(pval: ptr VALUE; pData: ptr cint): cuint {.inline.} =
  return SAPI().ValueIntData(pval, pData)

proc ValueIntDataSet*(pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
    inline.} =
  return SAPI().ValueIntDataSet(pval, data, `type`, units)

proc ValueInt64Data*(pval: ptr VALUE; pData: ptr cint): cuint {.inline.} =
  return SAPI().ValueInt64Data(pval, pData)

proc ValueInt64DataSet*(pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
    inline.} =
  return SAPI().ValueInt64DataSet(pval, data, `type`, units)

proc ValueFloatData*(pval: ptr VALUE; pData: ptr FLOAT_VALUE): cuint {.inline.} =
  return SAPI().ValueFloatData(pval, pData)

proc ValueFloatDataSet*(pval: ptr VALUE; data: FLOAT_VALUE; `type`: cuint; units: cuint): cuint {.
    inline.} =
  return SAPI().ValueFloatDataSet(pval, data, `type`, units)

proc ValueBinaryData*(pval: ptr VALUE; pBytes: ptr ptr byte; pnBytes: ptr cuint): cuint {.
    inline.} =
  return SAPI().ValueBinaryData(pval, pBytes, pnBytes)

proc ValueBinaryDataSet*(pval: ptr VALUE; pBytes: ptr byte; nBytes: cuint; `type`: cuint;
                        units: cuint): cuint {.inline.} =
  return SAPI().ValueBinaryDataSet(pval, pBytes, nBytes, `type`, units)

proc ValueElementsCount*(pval: ptr VALUE; pn: ptr cint): cuint {.inline.} =
  return SAPI().ValueElementsCount(pval, pn)

proc ValueNthElementValue*(pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueNthElementValue(pval, n, pretval)

proc ValueNthElementValueSet*(pval: ptr VALUE; n: cint; pval_to_set: ptr VALUE): cuint {.
    inline.} =
  return SAPI().ValueNthElementValueSet(pval, n, pval_to_set)

proc ValueNthElementKey*(pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.inline.} =
  return SAPI().ValueNthElementKey(pval, n, pretval)

proc ValueEnumElements*(pval: ptr VALUE; penum: ptr KeyValueCallback; param: pointer): cuint {.
    inline.} =
  return SAPI().ValueEnumElements(pval, penum, param)

proc ValueSetValueToKey*(pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): cuint {.
    inline.} =
  return SAPI().ValueSetValueToKey(pval, pkey, pval_to_set)

proc ValueGetValueOfKey*(pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): cuint {.
    inline.} =
  return SAPI().ValueGetValueOfKey(pval, pkey, pretval)

proc ValueToString*(pval: ptr VALUE; how: cuint): cuint {.inline.} =
  return SAPI().ValueToString(pval, how)

proc ValueFromString*(pval: ptr VALUE; str: ptr WideCString; strLength: cuint; how: cuint): cuint {.
    inline.} =
  return SAPI().ValueFromString(pval, str, strLength, how)

proc ValueInvoke*(pval: ptr VALUE; pthis: ptr VALUE; argc: cuint; argv: ptr VALUE;
                 pretval: ptr VALUE; url: ptr WideCString): cuint {.inline.} =
  return SAPI().ValueInvoke(pval, pthis, argc, argv, pretval, url)

proc ValueNativeFunctorSet*(pval: ptr VALUE; pinvoke: ptr NATIVE_FUNCTOR_INVOKE;
                           prelease: ptr NATIVE_FUNCTOR_RELEASE; tag: pointer): cuint {.
    inline.} =
  return SAPI().ValueNativeFunctorSet(pval, pinvoke, prelease, tag)

proc ValueIsNativeFunctor*(pval: ptr VALUE): bool {.inline.} =
  return SAPI().ValueIsNativeFunctor(pval)

proc Sciter_tv2V*(vm: HVM; script_value: tiscript_value; out_value: ptr VALUE;
                 isolate: bool): bool {.inline.} =
  return SAPI().Sciter_v2V(vm, script_value, out_value, isolate)

proc Sciter_V2tv*(vm: HVM; value: ptr VALUE; out_script_value: ptr tiscript_value): bool {.
    inline.} =
  return SAPI().Sciter_V2v(vm, value, out_script_value)

when defined(windows):
  proc SciterCreateOnDirectXWindow*(hwnd: HWINDOW; pSwapChain: ptr IDXGISwapChain): bool {.
      inline.} =
    return SAPI().SciterCreateOnDirectXWindow(hwnd, pSwapChain)

  proc SciterRenderOnDirectXWindow*(hwnd: HWINDOW; elementToRenderOrNull: HELEMENT;
                                   frontLayer: bool): bool {.inline.} =
    return SAPI().SciterRenderOnDirectXWindow(hwnd, elementToRenderOrNull,
        frontLayer)

  proc SciterRenderOnDirectXTexture*(hwnd: HWINDOW;
                                    elementToRenderOrNull: HELEMENT;
                                    surface: ptr IDXGISurface): bool {.inline.} =
    return SAPI().SciterRenderOnDirectXTexture(hwnd, elementToRenderOrNull, surface)
