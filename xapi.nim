## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## # 
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## # 
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## # 

include xtypes,xdom,xrequest,xdef,xvalue,xtiscript,xgraphics
type
  ISciterAPI* = object
    version*: cuint            ## # is zero for now
    SciterClassName*: proc (): WideCString {.cdecl.}
    SciterVersion*: proc (major: bool): cuint {.cdecl.}
    SciterDataReady*: proc (hwnd: HWINDOW; uri: WideCString; data: ptr byte;
                          dataLength: cuint): bool {.cdecl.}
    SciterDataReadyAsync*: proc (hwnd: HWINDOW; uri: WideCString; data: ptr byte;
                               dataLength: cuint; requestId: pointer): bool {.cdecl.}
    when defined(windows):
      SciterProc*: proc (hwnd: HWINDOW; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT
      SciterProcND*: proc (hwnd: HWINDOW; msg: UINT; wParam: WPARAM; lParam: LPARAM; pbHandled: ptr BOOL): LRESULT
    SciterLoadFile*: proc (hWndSciter: HWINDOW; filename: WideCString): bool {.cdecl.}
    SciterLoadHtml*: proc (hWndSciter: HWINDOW; html: ptr byte; htmlSize: cuint;
                         baseUrl: WideCString): bool {.cdecl.}
    SciterSetCallback*: proc (hWndSciter: HWINDOW; cb: LPSciterHostCallback;
                            cbParam: pointer) {.cdecl.}
    SciterSetMasterCSS*: proc (utf8: ptr byte; numBytes: cuint): bool {.cdecl.}
    SciterAppendMasterCSS*: proc (utf8: ptr byte; numBytes: cuint): bool {.cdecl.}
    SciterSetCSS*: proc (hWndSciter: HWINDOW; utf8: ptr byte; numBytes: cuint;
                       baseUrl: WideCString; mediaType: WideCString): bool {.cdecl.}
    SciterSetMediaType*: proc (hWndSciter: HWINDOW; mediaType: WideCString): bool {.
        cdecl.}
    SciterSetMediaVars*: proc (hWndSciter: HWINDOW; mediaVars: ptr Value): bool {.cdecl.}
    SciterGetMinWidth*: proc (hWndSciter: HWINDOW): cuint {.cdecl.}
    SciterGetMinHeight*: proc (hWndSciter: HWINDOW; width: cuint): cuint {.cdecl.}
    SciterCall*: proc (hWnd: HWINDOW; functionName: cstring; argc: cuint;
                     argv: ptr Value; retval: ptr Value): bool {.cdecl.}
    SciterEval*: proc (hwnd: HWINDOW; script: WideCString; scriptLength: cuint;
                     pretval: ptr Value): bool {.cdecl.}
    SciterUpdateWindow*: proc (hwnd: HWINDOW) {.cdecl.}
    when defined(windows):
      SciterTranslateMessage*: proc (lpMsg: ptr MSG): BOOL
    SciterSetOption*: proc (hWnd: HWINDOW; option: cuint; value: cuint): bool {.cdecl.}
    SciterGetPPI*: proc (hWndSciter: HWINDOW; px: ptr cuint; py: ptr cuint) {.cdecl.}
    SciterGetViewExpando*: proc (hwnd: HWINDOW; pval: ptr VALUE): bool {.cdecl.}
    when defined(windows):
      SciterRenderD2D*: proc (hWndSciter:HWINDOW, tgt:ptr ID2D1RenderTarget): BOOL
      SciterD2DFactory*: proc (ppf:ptr ID2D1FactoryPtr): BOOL
      SciterDWFactory*: proc (ppf:ptr IDWriteFactoryPtr): BOOL
    SciterGraphicsCaps*: proc (pcaps: ptr cuint): bool {.cdecl.}
    SciterSetHomeURL*: proc (hWndSciter: HWINDOW; baseUrl: WideCString): bool {.cdecl.}
    when defined(osx):
      SciterCreateNSView*: proc (frame:LPRECT): HWINDOW
    elif defined(linux):
      SciterCreateWidget*: proc (frame:ptr Rect): HWINDOW
    SciterCreateWindow*: proc (creationFlags: cuint; frame: ptr Rect;
                             delegate: ptr SciterWindowDelegate;
                             delegateParam: pointer; parent: HWINDOW): HWINDOW {.
        cdecl.}
    SciterSetupDebugOutput*: proc (hwndOrNull: HWINDOW; param: pointer; pfOutput: DEBUG_OUTPUT_PROC) {.
        cdecl.}               ## #|
               ## #| DOM Element API
               ## #|
    ## # HWINDOW or null if this is global output handler
    ## # param to be passed "as is" to the pfOutput
    ## # output function, output stream alike thing.
    Sciter_UseElement*: proc (he: HELEMENT): cint {.cdecl.}
    Sciter_UnuseElement*: proc (he: HELEMENT): cint {.cdecl.}
    SciterGetRootElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint {.cdecl.}
    SciterGetFocusElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint {.cdecl.}
    SciterFindElement*: proc (hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): cint {.cdecl.}
    SciterGetChildrenCount*: proc (he: HELEMENT; count: ptr cuint): cint {.cdecl.}
    SciterGetNthChild*: proc (he: HELEMENT; n: cuint; phe: ptr HELEMENT): cint {.cdecl.}
    SciterGetParentElement*: proc (he: HELEMENT; p_parent_he: ptr HELEMENT): cint {.
        cdecl.}
    SciterGetElementHtmlCB*: proc (he: HELEMENT; outer: bool;
                                 rcv: ptr LPCBYTE_RECEIVER; rcv_param: pointer): cint {.
        cdecl.}
    SciterGetElementTextCB*: proc (he: HELEMENT; rcv: ptr LPCWSTR_RECEIVER;
                                 rcv_param: pointer): cint {.cdecl.}
    SciterSetElementText*: proc (he: HELEMENT; utf16: WideCString; length: cuint): cint {.
        cdecl.}
    SciterGetAttributeCount*: proc (he: HELEMENT; p_count: ptr cuint): cint {.cdecl.}
    SciterGetNthAttributeNameCB*: proc (he: HELEMENT; n: cuint;
                                      rcv: ptr LPCSTR_RECEIVER; rcv_param: pointer): cint {.
        cdecl.}
    SciterGetNthAttributeValueCB*: proc (he: HELEMENT; n: cuint;
                                       rcv: ptr LPCWSTR_RECEIVER;
                                       rcv_param: pointer): cint {.cdecl.}
    SciterGetAttributeByNameCB*: proc (he: HELEMENT; name: cstring;
                                     rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
        cdecl.}
    SciterSetAttributeByName*: proc (he: HELEMENT; name: cstring; value: WideCString): cint {.
        cdecl.}
    SciterClearAttributes*: proc (he: HELEMENT): cint {.cdecl.}
    SciterGetElementIndex*: proc (he: HELEMENT; p_index: ptr cuint): cint {.cdecl.}
    SciterGetElementType*: proc (he: HELEMENT; p_type: cstringArray): cint {.cdecl.}
    SciterGetElementTypeCB*: proc (he: HELEMENT; rcv: ptr LPCSTR_RECEIVER;
                                 rcv_param: pointer): cint {.cdecl.}
    SciterGetStyleAttributeCB*: proc (he: HELEMENT; name: cstring;
                                    rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
        cdecl.}
    SciterSetStyleAttribute*: proc (he: HELEMENT; name: cstring; value: WideCString): cint {.
        cdecl.}
    SciterGetElementLocation*: proc (he: HELEMENT; p_location: ptr Rect; areas: cuint): cint {.
        cdecl.}               ## #ELEMENT_AREAS
    SciterScrollToView*: proc (he: HELEMENT; SciterScrollFlags: cuint): cint {.cdecl.}
    SciterUpdateElement*: proc (he: HELEMENT; andForceRender: bool): cint {.cdecl.}
    SciterRefreshElementArea*: proc (he: HELEMENT; rc: Rect): cint {.cdecl.}
    SciterSetCapture*: proc (he: HELEMENT): cint {.cdecl.}
    SciterReleaseCapture*: proc (he: HELEMENT): cint {.cdecl.}
    SciterGetElementHwnd*: proc (he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): cint {.
        cdecl.}
    SciterCombineURL*: proc (he: HELEMENT; szUrlBuffer: WideCString;
                           UrlBufferSize: cuint): cint {.cdecl.}
    SciterSelectElements*: proc (he: HELEMENT; CSS_selectors: cstring;
                               callback: ptr SciterElementCallback; param: pointer): cint {.
        cdecl.}
    SciterSelectElementsW*: proc (he: HELEMENT; CSS_selectors: WideCString;
                                callback: ptr SciterElementCallback; param: pointer): cint {.
        cdecl.}
    SciterSelectParent*: proc (he: HELEMENT; selector: cstring; depth: cuint;
                             heFound: ptr HELEMENT): cint {.cdecl.}
    SciterSelectParentW*: proc (he: HELEMENT; selector: WideCString; depth: cuint;
                              heFound: ptr HELEMENT): cint {.cdecl.}
    SciterSetElementHtml*: proc (he: HELEMENT; html: ptr byte; htmlLength: cuint;
                               where: cuint): cint {.cdecl.}
    SciterGetElementUID*: proc (he: HELEMENT; puid: ptr cuint): cint {.cdecl.}
    SciterGetElementByUID*: proc (hwnd: HWINDOW; uid: cuint; phe: ptr HELEMENT): cint {.
        cdecl.}
    SciterShowPopup*: proc (hePopup: HELEMENT; heAnchor: HELEMENT; placement: cuint): cint {.
        cdecl.}
    SciterShowPopupAt*: proc (hePopup: HELEMENT; pos: Point; animate: bool): cint {.cdecl.}
    SciterHidePopup*: proc (he: HELEMENT): cint {.cdecl.}
    SciterGetElementState*: proc (he: HELEMENT; pstateBits: ptr cuint): cint {.cdecl.}
    SciterSetElementState*: proc (he: HELEMENT; stateBitsToSet: cuint;
                                stateBitsToClear: cuint; updateView: bool): cint {.
        cdecl.}
    SciterCreateElement*: proc (tagname: cstring; textOrNull: WideCString;
                              phe: ptr HELEMENT): cint {.cdecl.} ## #out
    SciterCloneElement*: proc (he: HELEMENT; phe: ptr HELEMENT): cint {.cdecl.} ## #out
    SciterInsertElement*: proc (he: HELEMENT; hparent: HELEMENT; index: cuint): cint {.
        cdecl.}
    SciterDetachElement*: proc (he: HELEMENT): cint {.cdecl.}
    SciterDeleteElement*: proc (he: HELEMENT): cint {.cdecl.}
    SciterSetTimer*: proc (he: HELEMENT; milliseconds: cuint; timer_id: cuint): cint {.
        cdecl.}
    SciterDetachEventHandler*: proc (he: HELEMENT; pep: LPELEMENT_EVENT_PROC;
                                   tag: pointer): cint {.cdecl.}
    SciterAttachEventHandler*: proc (he: HELEMENT; pep: LPELEMENT_EVENT_PROC;
                                   tag: pointer): cint {.cdecl.}
    SciterWindowAttachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: LPELEMENT_EVENT_PROC; tag: pointer; subscription: cuint): cint {.cdecl.}
    SciterWindowDetachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.cdecl.}
    SciterSendEvent*: proc (he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                          reason: cuint; handled: ptr bool): cint {.cdecl.} ## #out
    SciterPostEvent*: proc (he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                          reason: cuint): cint {.cdecl.}
    SciterCallBehaviorMethod*: proc (he: HELEMENT; params: ptr METHOD_PARAMS): cint {.
        cdecl.}
    SciterRequestElementData*: proc (he: HELEMENT; url: WideCString; dataType: cuint;
                                   initiator: HELEMENT): cint {.cdecl.}
    SciterHttpRequest*: proc (he: HELEMENT; url: WideCString; dataType: cuint;
                            requestType: cuint; requestParams: ptr REQUEST_PARAM; nParams: cuint): cint {.
        cdecl.}               ## # element to deliver data
               ## # url
               ## # data type, see SciterResourceType.
               ## # one of REQUEST_TYPE values
               ## # parameters
    ## # number of parameters
    SciterGetScrollInfo*: proc (he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                              contentSize: ptr Size): cint {.cdecl.}
    SciterSetScrollPos*: proc (he: HELEMENT; scrollPos: Point; smooth: bool): cint {.
        cdecl.}
    SciterGetElementIntrinsicWidths*: proc (he: HELEMENT; pMinWidth: ptr cint;
        pMaxWidth: ptr cint): cint {.cdecl.}
    SciterGetElementIntrinsicHeight*: proc (he: HELEMENT; forWidth: cint;
        pHeight: ptr cint): cint {.cdecl.}
    SciterIsElementVisible*: proc (he: HELEMENT; pVisible: ptr bool): cint {.cdecl.}
    SciterIsElementEnabled*: proc (he: HELEMENT; pEnabled: ptr bool): cint {.cdecl.}
    SciterSortElements*: proc (he: HELEMENT; firstIndex: cuint; lastIndex: cuint;
                             cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): cint {.
        cdecl.}
    SciterSwapElements*: proc (he1: HELEMENT; he2: HELEMENT): cint {.cdecl.}
    SciterTraverseUIEvent*: proc (evt: cuint; eventCtlStruct: pointer;
                                bOutProcessed: ptr bool): cint {.cdecl.}
    SciterCallScriptingMethod*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                    argc: cuint; retval: ptr VALUE): cint {.cdecl.}
    SciterCallScriptingFunction*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                      argc: cuint; retval: ptr VALUE): cint {.cdecl.}
    SciterEvalElementScript*: proc (he: HELEMENT; script: WideCString;
                                  scriptLength: cuint; retval: ptr VALUE): cint {.
        cdecl.}
    SciterAttachHwndToElement*: proc (he: HELEMENT; hwnd: HWINDOW): cint {.cdecl.}
    SciterControlGetType*: proc (he: HELEMENT; pType: ptr cuint): cint {.cdecl.} ## #CTL_TYPE
    SciterGetValue*: proc (he: HELEMENT; pval: ptr VALUE): cint {.cdecl.}
    SciterSetValue*: proc (he: HELEMENT; pval: ptr VALUE): cint {.cdecl.}
    SciterGetExpando*: proc (he: HELEMENT; pval: ptr VALUE; forceCreation: bool): cint {.
        cdecl.}
    SciterGetObject*: proc (he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): cint {.
        cdecl.}
    SciterGetElementNamespace*: proc (he: HELEMENT; pval: ptr tiscript_value): cint {.
        cdecl.}
    SciterGetHighlightedElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): cint {.cdecl.}
    SciterSetHighlightedElement*: proc (hwnd: HWINDOW; he: HELEMENT): cint {.cdecl.} ## #|
                                                                             ## #| DOM Node API
                                                                             ## #|
    SciterNodeAddRef*: proc (hn: HNODE): cint {.cdecl.}
    SciterNodeRelease*: proc (hn: HNODE): cint {.cdecl.}
    SciterNodeCastFromElement*: proc (he: HELEMENT; phn: ptr HNODE): cint {.cdecl.}
    SciterNodeCastToElement*: proc (hn: HNODE; he: ptr HELEMENT): cint {.cdecl.}
    SciterNodeFirstChild*: proc (hn: HNODE; phn: ptr HNODE): cint {.cdecl.}
    SciterNodeLastChild*: proc (hn: HNODE; phn: ptr HNODE): cint {.cdecl.}
    SciterNodeNextSibling*: proc (hn: HNODE; phn: ptr HNODE): cint {.cdecl.}
    SciterNodePrevSibling*: proc (hn: HNODE; phn: ptr HNODE): cint {.cdecl.}
    SciterNodeParent*: proc (hnode: HNODE; pheParent: ptr HELEMENT): cint {.cdecl.}
    SciterNodeNthChild*: proc (hnode: HNODE; n: cuint; phn: ptr HNODE): cint {.cdecl.}
    SciterNodeChildrenCount*: proc (hnode: HNODE; pn: ptr cuint): cint {.cdecl.}
    SciterNodeType*: proc (hnode: HNODE; pNodeType: ptr cuint): cint {.cdecl.} ## #NODE_TYPE
    SciterNodeGetText*: proc (hnode: HNODE; rcv: ptr LPCWSTR_RECEIVER;
                            rcv_param: pointer): cint {.cdecl.}
    SciterNodeSetText*: proc (hnode: HNODE; text: WideCString; textLength: cuint): cint {.
        cdecl.}
    SciterNodeInsert*: proc (hnode: HNODE; where: cuint; ## #NODE_INS_TARGET
                           what: HNODE): cint {.cdecl.}
    SciterNodeRemove*: proc (hnode: HNODE; finalize: bool): cint {.cdecl.}
    SciterCreateTextNode*: proc (text: WideCString; textLength: cuint;
                               phnode: ptr HNODE): cint {.cdecl.}
    SciterCreateCommentNode*: proc (text: WideCString; textLength: cuint;
                                  phnode: ptr HNODE): cint {.cdecl.} ## #|
                                                                ## #| Value API
                                                                ## #|
    ValueInit*: proc (pval: ptr VALUE): cuint {.cdecl.}
    ValueClear*: proc (pval: ptr VALUE): cuint {.cdecl.}
    ValueCompare*: proc (pval1: ptr VALUE; pval2: ptr VALUE): cuint {.cdecl.}
    ValueCopy*: proc (pdst: ptr VALUE; psrc: ptr VALUE): cuint {.cdecl.}
    ValueIsolate*: proc (pdst: ptr VALUE): cuint {.cdecl.}
    ValueType*: proc (pval: ptr VALUE; pType: ptr cuint; pUnits: ptr cuint): cuint {.cdecl.}
    ValueStringData*: proc (pval: ptr VALUE; pChars: ptr WideCString;
                          pNumChars: ptr cuint): cuint {.cdecl.}
    ValueStringDataSet*: proc (pval: ptr VALUE; chars: WideCString; numChars: cuint;
                             units: cuint): cuint {.cdecl.}
    ValueIntData*: proc (pval: ptr VALUE; pData: ptr cint): cuint {.cdecl.}
    ValueIntDataSet*: proc (pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
        cdecl.}
    ValueInt64Data*: proc (pval: ptr VALUE; pData: ptr cint): cuint {.cdecl.}
    ValueInt64DataSet*: proc (pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
        cdecl.}
    ValueFloatData*: proc (pval: ptr VALUE; pData: ptr FLOAT_VALUE): cuint {.cdecl.}
    ValueFloatDataSet*: proc (pval: ptr VALUE; data: FLOAT_VALUE; `type`: cuint;
                            units: cuint): cuint {.cdecl.}
    ValueBinaryData*: proc (pval: ptr VALUE; pBytes: ptr ptr byte; pnBytes: ptr cuint): cuint {.
        cdecl.}
    ValueBinaryDataSet*: proc (pval: ptr VALUE; pBytes: ptr byte; nBytes: cuint;
                             `type`: cuint; units: cuint): cuint {.cdecl.}
    ValueElementsCount*: proc (pval: ptr VALUE; pn: ptr cint): cuint {.cdecl.}
    ValueNthElementValue*: proc (pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.
        cdecl.}
    ValueNthElementValueSet*: proc (pval: ptr VALUE; n: cint; pval_to_set: ptr VALUE): cuint {.
        cdecl.}
    ValueNthElementKey*: proc (pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.cdecl.}
    ValueEnumElements*: proc (pval: ptr VALUE; penum: ptr KeyValueCallback;
                            param: pointer): cuint {.cdecl.}
    ValueSetValueToKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): cuint {.
        cdecl.}
    ValueGetValueOfKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): cuint {.
        cdecl.}
    ValueToString*: proc (pval: ptr VALUE; how: cuint): cuint {.cdecl.} ## #VALUE_STRING_CVT_TYPE
    ValueFromString*: proc (pval: ptr VALUE; str: WideCString; strLength: cuint;
                          how: cuint): cuint {.cdecl.} ## #VALUE_STRING_CVT_TYPE
    ValueInvoke*: proc (pval: ptr VALUE; pthis: ptr VALUE; argc: cuint; argv: ptr VALUE;
                      pretval: ptr VALUE; url: WideCString): cuint {.cdecl.}
    ValueNativeFunctorSet*: proc (pval: ptr VALUE;
                                pinvoke: ptr NATIVE_FUNCTOR_INVOKE;
                                prelease: ptr NATIVE_FUNCTOR_RELEASE; tag: pointer): cuint {.
        cdecl.}
    ValueIsNativeFunctor*: proc (pval: ptr VALUE): bool {.cdecl.} ## # tiscript VM API
    TIScriptAPI*: proc (): ptr tiscript_native_interface {.cdecl.}
    SciterGetVM*: proc (hwnd: HWINDOW): HVM {.cdecl.}
    Sciter_tv2V*: proc (vm: HVM; script_value: tiscript_value; value: ptr VALUE;
                      isolate: bool): bool {.cdecl.}
    Sciter_V2tv*: proc (vm: HVM; valuev: ptr VALUE; script_value: ptr tiscript_value): bool {.
        cdecl.}
    SciterOpenArchive*: proc (archiveData: ptr byte; archiveDataLength: cuint): HSARCHIVE {.
        cdecl.}
    SciterGetArchiveItem*: proc (harc: HSARCHIVE; path: WideCString;
                               pdata: ptr ptr byte; pdataLength: ptr cuint): bool {.
        cdecl.}
    SciterCloseArchive*: proc (harc: HSARCHIVE): bool {.cdecl.}
    SciterFireEvent*: proc (evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool;
                          handled: ptr bool): cint {.cdecl.}
    SciterGetCallbackParam*: proc (hwnd: HWINDOW): pointer {.cdecl.}
    SciterPostCallback*: proc (hwnd: HWINDOW; wparam: cuint; lparam: cuint;
                             timeoutms: cuint): cuint {.cdecl.}
    GetSciterGraphicsAPI*: proc (): LPSciterGraphicsAPI {.cdecl.}
    GetSciterRequestAPI*: proc (): LPSciterRequestAPI {.cdecl.}
    when defined(windows):
      SciterCreateOnDirectXWindow*: proc (hwnd:HWINDOW, pSwapChain:ptr IDXGISwapChain): BOOL
      SciterRenderOnDirectXWindow*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, frontLayer:BOOL): BOOL
      SciterRenderOnDirectXTexture*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, surface:ptr IDXGISurface): BOOL
    # for_c2nim_only_very_bad_patch_so_do_not_pay_attention_to_this_field*: nil ## # 
                                                                            ## c2nim 
                                                                            ## needs this :(
  
  SciterAPI_ptr* = proc (): ptr ISciterAPI {.cdecl.}

include loader
## # defining "official" API functions:

proc SciterClassName*(): WideCString {.inline, cdecl.} =
  return SAPI().SciterClassName()

proc SciterVersion*(major: bool): cuint {.inline, cdecl.} =
  return SAPI().SciterVersion(major)

proc SciterDataReady*(hwnd: HWINDOW; uri: WideCString; data: ptr byte; dataLength: cuint): bool {.
    inline, cdecl.} =
  return SAPI().SciterDataReady(hwnd, uri, data, dataLength)

proc SciterDataReadyAsync*(hwnd: HWINDOW; uri: WideCString; data: ptr byte;
                          dataLength: cuint; requestId: pointer): bool {.inline, cdecl.} =
  return SAPI().SciterDataReadyAsync(hwnd, uri, data, dataLength, requestId)

when defined(windows):
  proc SciterProc*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM): LRESULT {.
      inline, cdecl.} =
    return SAPI().SciterProc(hwnd, msg, wParam, lParam)

  proc SciterProcND*(hwnd: HWINDOW; msg: cuint; wParam: WPARAM; lParam: LPARAM;
                    pbHandled: ptr bool): LRESULT {.inline, cdecl.} =
    return SAPI().SciterProcND(hwnd, msg, wParam, lParam, pbHandled)

proc SciterLoadFile*(hWndSciter: HWINDOW; filename: WideCString): bool {.inline, cdecl.} =
  return SAPI().SciterLoadFile(hWndSciter, filename)

proc SciterLoadHtml*(hWndSciter: HWINDOW; html: ptr byte; htmlSize: cuint;
                    baseUrl: WideCString): bool {.inline, cdecl.} =
  return SAPI().SciterLoadHtml(hWndSciter, html, htmlSize, baseUrl)

proc SciterSetCallback*(hWndSciter: HWINDOW; cb: LPSciterHostCallback;
                       cbParam: pointer) {.inline, cdecl.} =
  SAPI().SciterSetCallback(hWndSciter, cb, cbParam)

proc SciterSetMasterCSS*(utf8: ptr byte; numBytes: cuint): bool {.inline, cdecl.} =
  return SAPI().SciterSetMasterCSS(utf8, numBytes)

proc SciterAppendMasterCSS*(utf8: ptr byte; numBytes: cuint): bool {.inline, cdecl.} =
  return SAPI().SciterAppendMasterCSS(utf8, numBytes)

proc SciterSetCSS*(hWndSciter: HWINDOW; utf8: ptr byte; numBytes: cuint;
                  baseUrl: WideCString; mediaType: WideCString): bool {.inline, cdecl.} =
  return SAPI().SciterSetCSS(hWndSciter, utf8, numBytes, baseUrl, mediaType)

proc SciterSetMediaType*(hWndSciter: HWINDOW; mediaType: WideCString): bool {.inline,
    cdecl.} =
  return SAPI().SciterSetMediaType(hWndSciter, mediaType)

proc SciterSetMediaVars*(hWndSciter: HWINDOW; mediaVars: ptr Value): bool {.inline,
    cdecl.} =
  return SAPI().SciterSetMediaVars(hWndSciter, mediaVars)

proc SciterGetMinWidth*(hWndSciter: HWINDOW): cuint {.inline, cdecl.} =
  return SAPI().SciterGetMinWidth(hWndSciter)

proc SciterGetMinHeight*(hWndSciter: HWINDOW; width: cuint): cuint {.inline, cdecl.} =
  return SAPI().SciterGetMinHeight(hWndSciter, width)

proc SciterCall*(hWnd: HWINDOW; functionName: cstring; argc: cuint; argv: ptr Value;
                retval: ptr Value): bool {.inline, cdecl.} =
  return SAPI().SciterCall(hWnd, functionName, argc, argv, retval)

proc SciterEval*(hwnd: HWINDOW; script: WideCString; scriptLength: cuint;
                pretval: ptr Value): bool {.inline, cdecl.} =
  return SAPI().SciterEval(hwnd, script, scriptLength, pretval)

proc SciterUpdateWindow*(hwnd: HWINDOW) {.inline, cdecl.} =
  SAPI().SciterUpdateWindow(hwnd)

when defined(windows):
  proc SciterTranslateMessage*(lpMsg: ptr MSG): bool {.inline, cdecl.} =
    return SAPI().SciterTranslateMessage(lpMsg)

proc SciterSetOption*(hWnd: HWINDOW; option: cuint; value: cuint): bool {.inline, cdecl.} =
  return SAPI().SciterSetOption(hWnd, option, value)

proc SciterGetPPI*(hWndSciter: HWINDOW; px: ptr cuint; py: ptr cuint) {.inline, cdecl.} =
  SAPI().SciterGetPPI(hWndSciter, px, py)

proc SciterGetViewExpando*(hwnd: HWINDOW; pval: ptr VALUE): bool {.inline, cdecl.} =
  return SAPI().SciterGetViewExpando(hwnd, pval)

when defined(windows):
  proc SciterRenderD2D*(hWndSciter: HWINDOW; prt: ptr ID2D1RenderTarget): bool {.
      inline, cdecl.} =
    return SAPI().SciterRenderD2D(hWndSciter, prt)

  proc SciterD2DFactory*(ppf: ptr ptr ID2D1Factory): bool {.inline, cdecl.} =
    return SAPI().SciterD2DFactory(ppf)

  proc SciterDWFactory*(ppf: ptr ptr IDWriteFactory): bool {.inline, cdecl.} =
    return SAPI().SciterDWFactory(ppf)

proc SciterGraphicsCaps*(pcaps: ptr cuint): bool {.inline, cdecl.} =
  return SAPI().SciterGraphicsCaps(pcaps)

proc SciterSetHomeURL*(hWndSciter: HWINDOW; baseUrl: WideCString): bool {.inline, cdecl.} =
  return SAPI().SciterSetHomeURL(hWndSciter, baseUrl)

when defined(osx):
  proc SciterCreateNSView*(frame: ptr Rect): HWINDOW {.inline, cdecl.} =
    return SAPI().SciterCreateNSView(frame)

proc SciterCreateWindow*(creationFlags: cuint; frame: ptr Rect;
                        delegate: ptr SciterWindowDelegate; delegateParam: pointer;
                        parent: HWINDOW): HWINDOW {.inline, cdecl.} =
  return SAPI().SciterCreateWindow(creationFlags, frame, delegate, delegateParam,
                                  parent)

proc Sciter_UseElement*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().Sciter_UseElement(he)

proc Sciter_UnuseElement*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().Sciter_UnuseElement(he)

proc SciterGetRootElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterGetRootElement(hwnd, phe)

proc SciterGetFocusElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterGetFocusElement(hwnd, phe)

proc SciterFindElement*(hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterFindElement(hwnd, pt, phe)

proc SciterGetChildrenCount*(he: HELEMENT; count: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterGetChildrenCount(he, count)

proc SciterGetNthChild*(he: HELEMENT; n: cuint; phe: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterGetNthChild(he, n, phe)

proc SciterGetParentElement*(he: HELEMENT; p_parent_he: ptr HELEMENT): cint {.inline,
    cdecl.} =
  return SAPI().SciterGetParentElement(he, p_parent_he)

proc SciterGetElementHtmlCB*(he: HELEMENT; outer: bool; rcv: ptr LPCBYTE_RECEIVER;
                            rcv_param: pointer): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementHtmlCB(he, outer, rcv, rcv_param)

proc SciterGetElementTextCB*(he: HELEMENT; rcv: ptr LPCWSTR_RECEIVER;
                            rcv_param: pointer): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementTextCB(he, rcv, rcv_param)

proc SciterSetElementText*(he: HELEMENT; utf16: WideCString; length: cuint): cint {.
    inline, cdecl.} =
  return SAPI().SciterSetElementText(he, utf16, length)

proc SciterGetAttributeCount*(he: HELEMENT; p_count: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterGetAttributeCount(he, p_count)

proc SciterGetNthAttributeNameCB*(he: HELEMENT; n: cuint; rcv: ptr LPCSTR_RECEIVER;
                                 rcv_param: pointer): cint {.inline, cdecl.} =
  return SAPI().SciterGetNthAttributeNameCB(he, n, rcv, rcv_param)

proc SciterGetNthAttributeValueCB*(he: HELEMENT; n: cuint; rcv: ptr LPCWSTR_RECEIVER;
                                  rcv_param: pointer): cint {.inline, cdecl.} =
  return SAPI().SciterGetNthAttributeValueCB(he, n, rcv, rcv_param)

proc SciterGetAttributeByNameCB*(he: HELEMENT; name: cstring;
                                rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetAttributeByNameCB(he, name, rcv, rcv_param)

proc SciterSetAttributeByName*(he: HELEMENT; name: cstring; value: WideCString): cint {.
    inline, cdecl.} =
  return SAPI().SciterSetAttributeByName(he, name, value)

proc SciterClearAttributes*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterClearAttributes(he)

proc SciterGetElementIndex*(he: HELEMENT; p_index: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementIndex(he, p_index)

proc SciterGetElementType*(he: HELEMENT; p_type: cstringArray): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementType(he, p_type)

proc SciterGetElementTypeCB*(he: HELEMENT; rcv: ptr LPCSTR_RECEIVER;
                            rcv_param: pointer): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementTypeCB(he, rcv, rcv_param)

proc SciterGetStyleAttributeCB*(he: HELEMENT; name: cstring;
                               rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetStyleAttributeCB(he, name, rcv, rcv_param)

proc SciterSetStyleAttribute*(he: HELEMENT; name: cstring; value: WideCString): cint {.
    inline, cdecl.} =
  return SAPI().SciterSetStyleAttribute(he, name, value)

proc SciterGetElementLocation*(he: HELEMENT; p_location: ptr Rect; areas: cuint): cint {.
    inline, cdecl.} =
  ## #ELEMENT_AREAS
  return SAPI().SciterGetElementLocation(he, p_location, areas)

proc SciterScrollToView*(he: HELEMENT; SciterScrollFlags: cuint): cint {.inline, cdecl.} =
  return SAPI().SciterScrollToView(he, SciterScrollFlags)

proc SciterUpdateElement*(he: HELEMENT; andForceRender: bool): cint {.inline, cdecl.} =
  return SAPI().SciterUpdateElement(he, andForceRender)

proc SciterRefreshElementArea*(he: HELEMENT; rc: Rect): cint {.inline, cdecl.} =
  return SAPI().SciterRefreshElementArea(he, rc)

proc SciterSetCapture*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterSetCapture(he)

proc SciterReleaseCapture*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterReleaseCapture(he)

proc SciterGetElementHwnd*(he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetElementHwnd(he, p_hwnd, rootWindow)

proc SciterCombineURL*(he: HELEMENT; szUrlBuffer: WideCString; UrlBufferSize: cuint): cint {.
    inline, cdecl.} =
  return SAPI().SciterCombineURL(he, szUrlBuffer, UrlBufferSize)

proc SciterSelectElements*(he: HELEMENT; CSS_selectors: cstring;
                          callback: ptr SciterElementCallback; param: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterSelectElements(he, CSS_selectors, callback, param)

proc SciterSelectElementsW*(he: HELEMENT; CSS_selectors: WideCString;
                           callback: ptr SciterElementCallback; param: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterSelectElementsW(he, CSS_selectors, callback, param)

proc SciterSelectParent*(he: HELEMENT; selector: cstring; depth: cuint;
                        heFound: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterSelectParent(he, selector, depth, heFound)

proc SciterSelectParentW*(he: HELEMENT; selector: WideCString; depth: cuint;
                         heFound: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterSelectParentW(he, selector, depth, heFound)

proc SciterSetElementHtml*(he: HELEMENT; html: ptr byte; htmlLength: cuint; where: cuint): cint {.
    inline, cdecl.} =
  return SAPI().SciterSetElementHtml(he, html, htmlLength, where)

proc SciterGetElementUID*(he: HELEMENT; puid: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementUID(he, puid)

proc SciterGetElementByUID*(hwnd: HWINDOW; uid: cuint; phe: ptr HELEMENT): cint {.inline,
    cdecl.} =
  return SAPI().SciterGetElementByUID(hwnd, uid, phe)

proc SciterShowPopup*(hePopup: HELEMENT; heAnchor: HELEMENT; placement: cuint): cint {.
    inline, cdecl.} =
  return SAPI().SciterShowPopup(hePopup, heAnchor, placement)

proc SciterShowPopupAt*(hePopup: HELEMENT; pos: Point; animate: bool): cint {.inline,
    cdecl.} =
  return SAPI().SciterShowPopupAt(hePopup, pos, animate)

proc SciterHidePopup*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterHidePopup(he)

proc SciterGetElementState*(he: HELEMENT; pstateBits: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementState(he, pstateBits)

proc SciterSetElementState*(he: HELEMENT; stateBitsToSet: cuint;
                           stateBitsToClear: cuint; updateView: bool): cint {.inline,
    cdecl.} =
  return SAPI().SciterSetElementState(he, stateBitsToSet, stateBitsToClear,
                                     updateView)

proc SciterCreateElement*(tagname: cstring; textOrNull: WideCString;
                         phe: ptr HELEMENT): cint {.inline, cdecl.} =
  ## #out
  return SAPI().SciterCreateElement(tagname, textOrNull, phe)

proc SciterCloneElement*(he: HELEMENT; phe: ptr HELEMENT): cint {.inline, cdecl.} =
  ## #out
  return SAPI().SciterCloneElement(he, phe)

proc SciterInsertElement*(he: HELEMENT; hparent: HELEMENT; index: cuint): cint {.inline,
    cdecl.} =
  return SAPI().SciterInsertElement(he, hparent, index)

proc SciterDetachElement*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterDetachElement(he)

proc SciterDeleteElement*(he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterDeleteElement(he)

proc SciterSetTimer*(he: HELEMENT; milliseconds: cuint; timer_id: cuint): cint {.inline,
    cdecl.} =
  return SAPI().SciterSetTimer(he, milliseconds, timer_id)

proc SciterDetachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterDetachEventHandler(he, pep, tag)

proc SciterAttachEventHandler*(he: HELEMENT; pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterAttachEventHandler(he, pep, tag)

proc SciterWindowAttachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer;
                                    subscription: cuint): cint {.inline, cdecl.} =
  return SAPI().SciterWindowAttachEventHandler(hwndLayout, pep, tag, subscription)

proc SciterWindowDetachEventHandler*(hwndLayout: HWINDOW;
                                    pep: LPELEMENT_EVENT_PROC; tag: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterWindowDetachEventHandler(hwndLayout, pep, tag)

proc SciterSendEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint; handled: ptr bool): cint {.inline, cdecl.} =
  ## #out
  return SAPI().SciterSendEvent(he, appEventCode, heSource, reason, handled)

proc SciterPostEvent*(he: HELEMENT; appEventCode: cuint; heSource: HELEMENT;
                     reason: cuint): cint {.inline, cdecl.} =
  return SAPI().SciterPostEvent(he, appEventCode, heSource, reason)

proc SciterFireEvent*(evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool; handled: ptr bool): cint {.
    inline, cdecl.} =
  return SAPI().SciterFireEvent(evt, post, handled)

proc SciterCallBehaviorMethod*(he: HELEMENT; params: ptr METHOD_PARAMS): cint {.inline,
    cdecl.} =
  return SAPI().SciterCallBehaviorMethod(he, params)

proc SciterRequestElementData*(he: HELEMENT; url: WideCString; dataType: cuint;
                              initiator: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterRequestElementData(he, url, dataType, initiator)

proc SciterHttpRequest*(he: HELEMENT; url: WideCString; dataType: cuint;
                       requestType: cuint; requestParams: ptr REQUEST_PARAM;
                       nParams: cuint): cint {.inline, cdecl.} =
  return SAPI().SciterHttpRequest(he, url, dataType, requestType, requestParams,
                                 nParams)

proc SciterGetScrollInfo*(he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                         contentSize: ptr Size): cint {.inline, cdecl.} =
  return SAPI().SciterGetScrollInfo(he, scrollPos, viewRect, contentSize)

proc SciterSetScrollPos*(he: HELEMENT; scrollPos: Point; smooth: bool): cint {.inline,
    cdecl.} =
  return SAPI().SciterSetScrollPos(he, scrollPos, smooth)

proc SciterGetElementIntrinsicWidths*(he: HELEMENT; pMinWidth: ptr cint;
                                     pMaxWidth: ptr cint): cint {.inline, cdecl.} =
  return SAPI().SciterGetElementIntrinsicWidths(he, pMinWidth, pMaxWidth)

proc SciterGetElementIntrinsicHeight*(he: HELEMENT; forWidth: cint; pHeight: ptr cint): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetElementIntrinsicHeight(he, forWidth, pHeight)

proc SciterIsElementVisible*(he: HELEMENT; pVisible: ptr bool): cint {.inline, cdecl.} =
  return SAPI().SciterIsElementVisible(he, pVisible)

proc SciterIsElementEnabled*(he: HELEMENT; pEnabled: ptr bool): cint {.inline, cdecl.} =
  return SAPI().SciterIsElementEnabled(he, pEnabled)

proc SciterSortElements*(he: HELEMENT; firstIndex: cuint; lastIndex: cuint;
                        cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterSortElements(he, firstIndex, lastIndex, cmpFunc, cmpFuncParam)

proc SciterSwapElements*(he1: HELEMENT; he2: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterSwapElements(he1, he2)

proc SciterTraverseUIEvent*(evt: cuint; eventCtlStruct: pointer;
                           bOutProcessed: ptr bool): cint {.inline, cdecl.} =
  return SAPI().SciterTraverseUIEvent(evt, eventCtlStruct, bOutProcessed)

proc SciterCallScriptingMethod*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                               argc: cuint; retval: ptr VALUE): cint {.inline, cdecl.} =
  return SAPI().SciterCallScriptingMethod(he, name, argv, argc, retval)

proc SciterCallScriptingFunction*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                                 argc: cuint; retval: ptr VALUE): cint {.inline, cdecl.} =
  return SAPI().SciterCallScriptingFunction(he, name, argv, argc, retval)

proc SciterEvalElementScript*(he: HELEMENT; script: WideCString; scriptLength: cuint;
                             retval: ptr VALUE): cint {.inline, cdecl.} =
  return SAPI().SciterEvalElementScript(he, script, scriptLength, retval)

proc SciterAttachHwndToElement*(he: HELEMENT; hwnd: HWINDOW): cint {.inline, cdecl.} =
  return SAPI().SciterAttachHwndToElement(he, hwnd)

proc SciterControlGetType*(he: HELEMENT; pType: ptr cuint): cint {.inline, cdecl.} =
  ## #CTL_TYPE
  return SAPI().SciterControlGetType(he, pType)

proc SciterGetValue*(he: HELEMENT; pval: ptr VALUE): cint {.inline, cdecl.} =
  return SAPI().SciterGetValue(he, pval)

proc SciterSetValue*(he: HELEMENT; pval: ptr VALUE): cint {.inline, cdecl.} =
  return SAPI().SciterSetValue(he, pval)

proc SciterGetExpando*(he: HELEMENT; pval: ptr VALUE; forceCreation: bool): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetExpando(he, pval, forceCreation)

proc SciterGetObject*(he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): cint {.
    inline, cdecl.} =
  return SAPI().SciterGetObject(he, pval, forceCreation)

proc SciterGetElementNamespace*(he: HELEMENT; pval: ptr tiscript_value): cint {.inline,
    cdecl.} =
  return SAPI().SciterGetElementNamespace(he, pval)

proc SciterGetHighlightedElement*(hwnd: HWINDOW; phe: ptr HELEMENT): cint {.inline,
    cdecl.} =
  return SAPI().SciterGetHighlightedElement(hwnd, phe)

proc SciterSetHighlightedElement*(hwnd: HWINDOW; he: HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterSetHighlightedElement(hwnd, he)

proc SciterNodeAddRef*(hn: HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeAddRef(hn)

proc SciterNodeRelease*(hn: HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeRelease(hn)

proc SciterNodeCastFromElement*(he: HELEMENT; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeCastFromElement(he, phn)

proc SciterNodeCastToElement*(hn: HNODE; he: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterNodeCastToElement(hn, he)

proc SciterNodeFirstChild*(hn: HNODE; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeFirstChild(hn, phn)

proc SciterNodeLastChild*(hn: HNODE; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeLastChild(hn, phn)

proc SciterNodeNextSibling*(hn: HNODE; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeNextSibling(hn, phn)

proc SciterNodePrevSibling*(hn: HNODE; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodePrevSibling(hn, phn)

proc SciterNodeParent*(hnode: HNODE; pheParent: ptr HELEMENT): cint {.inline, cdecl.} =
  return SAPI().SciterNodeParent(hnode, pheParent)

proc SciterNodeNthChild*(hnode: HNODE; n: cuint; phn: ptr HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeNthChild(hnode, n, phn)

proc SciterNodeChildrenCount*(hnode: HNODE; pn: ptr cuint): cint {.inline, cdecl.} =
  return SAPI().SciterNodeChildrenCount(hnode, pn)

proc SciterNodeType*(hnode: HNODE; pNodeType: ptr cuint): cint {.inline, cdecl.} =
  ## #NODE_TYPE
  return SAPI().SciterNodeType(hnode, pNodeType)

proc SciterNodeGetText*(hnode: HNODE; rcv: ptr LPCWSTR_RECEIVER; rcv_param: pointer): cint {.
    inline, cdecl.} =
  return SAPI().SciterNodeGetText(hnode, rcv, rcv_param)

proc SciterNodeSetText*(hnode: HNODE; text: WideCString; textLength: cuint): cint {.
    inline, cdecl.} =
  return SAPI().SciterNodeSetText(hnode, text, textLength)

proc SciterNodeInsert*(hnode: HNODE; where: cuint; ## #NODE_INS_TARGET
                      what: HNODE): cint {.inline, cdecl.} =
  return SAPI().SciterNodeInsert(hnode, where, what)

proc SciterNodeRemove*(hnode: HNODE; finalize: bool): cint {.inline, cdecl.} =
  return SAPI().SciterNodeRemove(hnode, finalize)

proc SciterCreateTextNode*(text: WideCString; textLength: cuint; phnode: ptr HNODE): cint {.
    inline, cdecl.} =
  return SAPI().SciterCreateTextNode(text, textLength, phnode)

proc SciterCreateCommentNode*(text: WideCString; textLength: cuint; phnode: ptr HNODE): cint {.
    inline, cdecl.} =
  return SAPI().SciterCreateCommentNode(text, textLength, phnode)

proc SciterGetVM*(hwnd: HWINDOW): HVM {.inline, cdecl.} =
  return SAPI().SciterGetVM(hwnd)

proc ValueInit*(pval: ptr VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueInit(pval)

proc ValueClear*(pval: ptr VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueClear(pval)

proc ValueCompare*(pval1: ptr VALUE; pval2: ptr VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueCompare(pval1, pval2)

proc ValueCopy*(pdst: ptr VALUE; psrc: ptr VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueCopy(pdst, psrc)

proc ValueIsolate*(pdst: ptr VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueIsolate(pdst)

proc ValueType*(pval: ptr VALUE; pType: ptr cuint; pUnits: ptr cuint): cuint {.inline, cdecl.} =
  return SAPI().ValueType(pval, pType, pUnits)

proc ValueStringData*(pval: ptr VALUE; pChars: ptr WideCString; pNumChars: ptr cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueStringData(pval, pChars, pNumChars)

proc ValueStringDataSet*(pval: ptr VALUE; chars: WideCString; numChars: cuint;
                        units: cuint): cuint {.inline, cdecl.} =
  return SAPI().ValueStringDataSet(pval, chars, numChars, units)

proc ValueIntData*(pval: ptr VALUE; pData: ptr cint): cuint {.inline, cdecl.} =
  return SAPI().ValueIntData(pval, pData)

proc ValueIntDataSet*(pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueIntDataSet(pval, data, `type`, units)

proc ValueInt64Data*(pval: ptr VALUE; pData: ptr cint): cuint {.inline, cdecl.} =
  return SAPI().ValueInt64Data(pval, pData)

proc ValueInt64DataSet*(pval: ptr VALUE; data: cint; `type`: cuint; units: cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueInt64DataSet(pval, data, `type`, units)

proc ValueFloatData*(pval: ptr VALUE; pData: ptr FLOAT_VALUE): cuint {.inline, cdecl.} =
  return SAPI().ValueFloatData(pval, pData)

proc ValueFloatDataSet*(pval: ptr VALUE; data: FLOAT_VALUE; `type`: cuint; units: cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueFloatDataSet(pval, data, `type`, units)

proc ValueBinaryData*(pval: ptr VALUE; pBytes: ptr ptr byte; pnBytes: ptr cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueBinaryData(pval, pBytes, pnBytes)

proc ValueBinaryDataSet*(pval: ptr VALUE; pBytes: ptr byte; nBytes: cuint; `type`: cuint;
                        units: cuint): cuint {.inline, cdecl.} =
  return SAPI().ValueBinaryDataSet(pval, pBytes, nBytes, `type`, units)

proc ValueElementsCount*(pval: ptr VALUE; pn: ptr cint): cuint {.inline, cdecl.} =
  return SAPI().ValueElementsCount(pval, pn)

proc ValueNthElementValue*(pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.inline,
    cdecl.} =
  return SAPI().ValueNthElementValue(pval, n, pretval)

proc ValueNthElementValueSet*(pval: ptr VALUE; n: cint; pval_to_set: ptr VALUE): cuint {.
    inline, cdecl.} =
  return SAPI().ValueNthElementValueSet(pval, n, pval_to_set)

proc ValueNthElementKey*(pval: ptr VALUE; n: cint; pretval: ptr VALUE): cuint {.inline,
    cdecl.} =
  return SAPI().ValueNthElementKey(pval, n, pretval)

proc ValueEnumElements*(pval: ptr VALUE; penum: ptr KeyValueCallback; param: pointer): cuint {.
    inline, cdecl.} =
  return SAPI().ValueEnumElements(pval, penum, param)

proc ValueSetValueToKey*(pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): cuint {.
    inline, cdecl.} =
  return SAPI().ValueSetValueToKey(pval, pkey, pval_to_set)

proc ValueGetValueOfKey*(pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): cuint {.
    inline, cdecl.} =
  return SAPI().ValueGetValueOfKey(pval, pkey, pretval)

proc ValueToString*(pval: ptr VALUE; how: cuint): cuint {.inline, cdecl.} =
  return SAPI().ValueToString(pval, how)

proc ValueFromString*(pval: ptr VALUE; str: WideCString; strLength: cuint; how: cuint): cuint {.
    inline, cdecl.} =
  return SAPI().ValueFromString(pval, str, strLength, how)

proc ValueInvoke*(pval: ptr VALUE; pthis: ptr VALUE; argc: cuint; argv: ptr VALUE;
                 pretval: ptr VALUE; url: WideCString): cuint {.inline, cdecl.} =
  return SAPI().ValueInvoke(pval, pthis, argc, argv, pretval, url)

proc ValueNativeFunctorSet*(pval: ptr VALUE; pinvoke: ptr NATIVE_FUNCTOR_INVOKE;
                           prelease: ptr NATIVE_FUNCTOR_RELEASE; tag: pointer): cuint {.
    inline, cdecl.} =
  return SAPI().ValueNativeFunctorSet(pval, pinvoke, prelease, tag)

proc ValueIsNativeFunctor*(pval: ptr VALUE): bool {.inline, cdecl.} =
  return SAPI().ValueIsNativeFunctor(pval)

## # conversion between script (managed) value and the VALUE ( com::variant alike thing )

proc Sciter_tv2V*(vm: HVM; script_value: tiscript_value; out_value: ptr VALUE;
                 isolate: bool): bool {.inline, cdecl.} =
  return SAPI().Sciter_tv2V(vm, script_value, out_value, isolate)

proc Sciter_V2tv*(vm: HVM; value: ptr VALUE; out_script_value: ptr tiscript_value): bool {.
    inline, cdecl.} =
  return SAPI().Sciter_V2tv(vm, value, out_script_value)

when defined(windows):
  proc SciterCreateOnDirectXWindow*(hwnd: HWINDOW; pSwapChain: ptr IDXGISwapChain): bool {.
      inline, cdecl.} =
    return SAPI().SciterCreateOnDirectXWindow(hwnd, pSwapChain)

  proc SciterRenderOnDirectXWindow*(hwnd: HWINDOW; elementToRenderOrNull: HELEMENT;
                                   frontLayer: bool): bool {.inline, cdecl.} =
    return SAPI().SciterRenderOnDirectXWindow(hwnd, elementToRenderOrNull,
        frontLayer)

  proc SciterRenderOnDirectXTexture*(hwnd: HWINDOW;
                                    elementToRenderOrNull: HELEMENT;
                                    surface: ptr IDXGISurface): bool {.inline, cdecl.} =
    return SAPI().SciterRenderOnDirectXTexture(hwnd, elementToRenderOrNull, surface)
