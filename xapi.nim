## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## #
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## #
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## #

include xtypes,xdom,xgraphics,xvalue,xtiscript,xbehavior,xrequest,xdef,converters
type
  ISciterAPI* = object
    version*: uint32           ## # is zero for now
    SciterClassName*: proc (): WideCString {.cdecl.}
    SciterVersion*: proc (major: bool): uint32 {.cdecl.}
    SciterDataReady*: proc (hwnd: HWINDOW; uri: WideCString; data: pointer;
                        dataLength: uint32): bool {.cdecl.}
    SciterDataReadyAsync*: proc (hwnd: HWINDOW; uri: WideCString; data: pointer;
                                dataLength: uint32; requestId: pointer): bool {.cdecl.}
    when defined(windows):
    SciterProc*: proc (hwnd: HWINDOW; msg: uint32; wParam: WPARAM; lParam: LPARAM): LRESULT  {.stdcall.}
    SciterProcND*: proc (hwnd: HWINDOW; msg: uint32; wParam: WPARAM; lParam: LPARAM; pbHandled: ptr bool): LRESULT  {.stdcall.}
    SciterLoadFile*: proc (hWndSciter: HWINDOW; filename: WideCString): bool {.cdecl.}
    SciterLoadHtml*: proc (hWndSciter: HWINDOW; html: pointer; htmlSize: uint32;
                        baseUrl: WideCString): bool {.cdecl.}
    SciterSetCallback*: proc (hWndSciter: HWINDOW; cb: SciterHostCallback;
                            cbParam: pointer) {.cdecl.}
    SciterSetMasterCSS*: proc (utf8: pointer; numBytes: uint32): bool {.cdecl.}
    SciterAppendMasterCSS*: proc (utf8: pointer; numBytes: uint32): bool {.cdecl.}
    SciterSetCSS*: proc (hWndSciter: HWINDOW; utf8: pointer; numBytes: uint32;
                        baseUrl: WideCString; mediaType: WideCString): bool {.cdecl.}
    SciterSetMediaType*: proc (hWndSciter: HWINDOW; mediaType: WideCString): bool {.
        cdecl.}
    SciterSetMediaVars*: proc (hWndSciter: HWINDOW; mediaVars: ptr Value): bool {.cdecl.}
    SciterGetMinWidth*: proc (hWndSciter: HWINDOW): uint32 {.cdecl.}
    SciterGetMinHeight*: proc (hWndSciter: HWINDOW; width: uint32): uint32 {.cdecl.}
    SciterCall*: proc (hWnd: HWINDOW; functionName: cstring; argc: uint32;
                    argv: ptr Value; retval: ptr Value): bool {.cdecl.}
    SciterEval*: proc (hwnd: HWINDOW; script: WideCString; scriptLength: uint32;
                    pretval: ptr Value): bool {.cdecl.}
    SciterUpdateWindow*: proc (hwnd: HWINDOW) {.cdecl.}
    when defined(windows):
    SciterTranslateMessage*: proc (lpMsg: ptr MSG): bool  {.stdcall.}
    SciterSetOption*: proc (hWnd: HWINDOW; option: uint32; value: uint32): bool {.cdecl.}
    SciterGetPPI*: proc (hWndSciter: HWINDOW; px: ptr uint32; py: ptr uint32) {.cdecl.}
    SciterGetViewExpando*: proc (hwnd: HWINDOW; pval: ptr VALUE): bool {.cdecl.}
    when defined(windows):
    SciterRenderD2D*: proc (hWndSciter:HWINDOW, tgt:pointer): bool {.stdcall.}
    SciterD2DFactory*: proc (ppf: pointer): bool {.stdcall.}
    SciterDWFactory*: proc (ppf: pointer): bool {.stdcall.}
    SciterGraphicsCaps*: proc (pcaps: ptr uint32): bool {.cdecl.}
    SciterSetHomeURL*: proc (hWndSciter: HWINDOW; baseUrl: WideCString): bool {.cdecl.}
    when defined(osx):
    SciterCreateNSView*: proc (frame:LPRECT): HWINDOW {.cdecl.}
    elif defined(posix):
    SciterCreateWidget*: proc (frame:ptr Rect): HWINDOW {.cdecl.}
    SciterCreateWindow*: proc (creationFlags: uint32; frame: ptr Rect;
                            delegate: SciterWindowDelegate;
                            delegateParam: pointer; parent: HWINDOW): HWINDOW {.
        cdecl.}
    SciterSetupDebugOutput*: proc (hwndOrNull: HWINDOW; param: pointer; pfOutput: DEBUG_OUTPUT_PROC) {.
        cdecl.}               ## #|
                ## #| DOM Element API
                ## #|
    ## # HWINDOW or null if this is global output handler
    ## # param to be passed "as is" to the pfOutput
    ## # output function, output stream alike thing.
    Sciter_UseElement*: proc (he: HELEMENT): int32 {.cdecl.}
    Sciter_UnuseElement*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterGetRootElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.cdecl.}
    SciterGetFocusElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.cdecl.}
    SciterFindElement*: proc (hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): int32 {.cdecl.}
    SciterGetChildrenCount*: proc (he: HELEMENT; count: ptr uint32): int32 {.cdecl.}
    SciterGetNthChild*: proc (he: HELEMENT; n: uint32; phe: ptr HELEMENT): int32 {.cdecl.}
    SciterGetParentElement*: proc (he: HELEMENT; p_parent_he: ptr HELEMENT): int32 {.
        cdecl.}
    SciterGetElementHtmlCB*: proc (he: HELEMENT; outer: bool;
                                rcv: LPCBYTE_RECEIVER; rcv_param: pointer): int32 {.
        cdecl.}
    SciterGetElementTextCB*: proc (he: HELEMENT; rcv: LPCWSTR_RECEIVER;
                                rcv_param: pointer): int32 {.cdecl.}
    SciterSetElementText*: proc (he: HELEMENT; utf16: WideCString; length: uint32): int32 {.
        cdecl.}
    SciterGetAttributeCount*: proc (he: HELEMENT; p_count: ptr uint32): int32 {.cdecl.}
    SciterGetNthAttributeNameCB*: proc (he: HELEMENT; n: uint32;
                                    rcv: LPCSTR_RECEIVER; rcv_param: pointer): int32 {.
        cdecl.}
    SciterGetNthAttributeValueCB*: proc (he: HELEMENT; n: uint32;
                                        rcv: LPCWSTR_RECEIVER;
                                        rcv_param: pointer): int32 {.cdecl.}
    SciterGetAttributeByNameCB*: proc (he: HELEMENT; name: cstring;
                                    rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
        cdecl.}
    SciterSetAttributeByName*: proc (he: HELEMENT; name: cstring; value: WideCString): int32 {.
        cdecl.}
    SciterClearAttributes*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterGetElementIndex*: proc (he: HELEMENT; p_index: ptr uint32): int32 {.cdecl.}
    SciterGetElementType*: proc (he: HELEMENT; p_type: ptr cstring): int32 {.cdecl.}
    SciterGetElementTypeCB*: proc (he: HELEMENT; rcv: LPCSTR_RECEIVER;
                                rcv_param: pointer): int32 {.cdecl.}
    SciterGetStyleAttributeCB*: proc (he: HELEMENT; name: cstring;
                                    rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
        cdecl.}
    SciterSetStyleAttribute*: proc (he: HELEMENT; name: cstring; value: WideCString): int32 {.
        cdecl.}
    SciterGetElementLocation*: proc (he: HELEMENT; p_location: ptr Rect; areas: uint32): int32 {.
        cdecl.}               ## #ELEMENT_AREAS
    SciterScrollToView*: proc (he: HELEMENT; SciterScrollFlags: uint32): int32 {.cdecl.}
    SciterUpdateElement*: proc (he: HELEMENT; andForceRender: bool): int32 {.cdecl.}
    SciterRefreshElementArea*: proc (he: HELEMENT; rc: Rect): int32 {.cdecl.}
    SciterSetCapture*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterReleaseCapture*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterGetElementHwnd*: proc (he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): int32 {.
        cdecl.}
    SciterCombineURL*: proc (he: HELEMENT; szUrlBuffer: WideCString;
                            UrlBufferSize: uint32): int32 {.cdecl.}
    SciterSelectElements*: proc (he: HELEMENT; CSS_selectors: cstring;
                                callback: SciterElementCallback; param: pointer): int32 {.
        cdecl.}
    SciterSelectElementsW*: proc (he: HELEMENT; CSS_selectors: WideCString;
                                callback: SciterElementCallback; param: pointer): int32 {.
        cdecl.}
    SciterSelectParent*: proc (he: HELEMENT; selector: cstring; depth: uint32;
                            heFound: ptr HELEMENT): int32 {.cdecl.}
    SciterSelectParentW*: proc (he: HELEMENT; selector: WideCString; depth: uint32;
                            heFound: ptr HELEMENT): int32 {.cdecl.}
    SciterSetElementHtml*: proc (he: HELEMENT; html: ptr byte; htmlLength: uint32;
                                where: uint32): int32 {.cdecl.}
    SciterGetElementUID*: proc (he: HELEMENT; puid: ptr uint32): int32 {.cdecl.}
    SciterGetElementByUID*: proc (hwnd: HWINDOW; uid: uint32; phe: ptr HELEMENT): int32 {.
        cdecl.}
    SciterShowPopup*: proc (hePopup: HELEMENT; heAnchor: HELEMENT; placement: uint32): int32 {.
        cdecl.}
    SciterShowPopupAt*: proc (hePopup: HELEMENT; pos: Point; animate: bool): int32 {.
        cdecl.}
    SciterHidePopup*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterGetElementState*: proc (he: HELEMENT; pstateBits: ptr uint32): int32 {.cdecl.}
    SciterSetElementState*: proc (he: HELEMENT; stateBitsToSet: uint32;
                                stateBitsToClear: uint32; updateView: bool): int32 {.
        cdecl.}
    SciterCreateElement*: proc (tagname: cstring; textOrNull: WideCString;
                            phe: ptr HELEMENT): int32 {.cdecl.} ## #out
    SciterCloneElement*: proc (he: HELEMENT; phe: ptr HELEMENT): int32 {.cdecl.} ## #out
    SciterInsertElement*: proc (he: HELEMENT; hparent: HELEMENT; index: uint32): int32 {.
        cdecl.}
    SciterDetachElement*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterDeleteElement*: proc (he: HELEMENT): int32 {.cdecl.}
    SciterSetTimer*: proc (he: HELEMENT; milliseconds: uint32; timer_id: uint32): int32 {.
        cdecl.}
    SciterDetachEventHandler*: proc (he: HELEMENT; pep: ElementEventProc; tag: pointer): int32 {.
        cdecl.}
    SciterAttachEventHandler*: proc (he: HELEMENT; pep: ElementEventProc; tag: pointer): int32 {.
        cdecl.}
    SciterWindowAttachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: ElementEventProc; tag: pointer; subscription: uint32): int32 {.cdecl.}
    SciterWindowDetachEventHandler*: proc (hwndLayout: HWINDOW;
        pep: ElementEventProc; tag: pointer): int32 {.cdecl.}
    SciterSendEvent*: proc (he: HELEMENT; appEventCode: uint32; heSource: HELEMENT;
                        reason: uint32; handled: ptr bool): int32 {.cdecl.} ## #out
    SciterPostEvent*: proc (he: HELEMENT; appEventCode: uint32; heSource: HELEMENT;
                        reason: uint32): int32 {.cdecl.}
    SciterCallBehaviorMethod*: proc (he: HELEMENT; params: ptr METHOD_PARAMS): int32 {.
        cdecl.}
    SciterRequestElementData*: proc (he: HELEMENT; url: WideCString; dataType: uint32;
                                    initiator: HELEMENT): int32 {.cdecl.}
    SciterHttpRequest*: proc (he: HELEMENT; url: WideCString; dataType: uint32;
                            requestType: uint32; requestParams: ptr REQUEST_PARAM; nParams: uint32): int32 {.
        cdecl.}               ## # element to deliver data
                ## # url
                ## # data type, see SciterResourceType.
                ## # one of REQUEST_TYPE values
                ## # parameters
    ## # number of parameters
    SciterGetScrollInfo*: proc (he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                            contentSize: ptr Size): int32 {.cdecl.}
    SciterSetScrollPos*: proc (he: HELEMENT; scrollPos: Point; smooth: bool): int32 {.
        cdecl.}
    SciterGetElementIntrinsicWidths*: proc (he: HELEMENT; pMinWidth: ptr int32;
        pMaxWidth: ptr int32): int32 {.cdecl.}
    SciterGetElementIntrinsicHeight*: proc (he: HELEMENT; forWidth: int32;
        pHeight: ptr int32): int32 {.cdecl.}
    SciterIsElementVisible*: proc (he: HELEMENT; pVisible: ptr bool): int32 {.cdecl.}
    SciterIsElementEnabled*: proc (he: HELEMENT; pEnabled: ptr bool): int32 {.cdecl.}
    SciterSortElements*: proc (he: HELEMENT; firstIndex: uint32; lastIndex: uint32;
                            cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): int32 {.
        cdecl.}
    SciterSwapElements*: proc (he1: HELEMENT; he2: HELEMENT): int32 {.cdecl.}
    SciterTraverseUIEvent*: proc (evt: uint32; eventCtlStruct: pointer;
                                bOutProcessed: ptr bool): int32 {.cdecl.}
    SciterCallScriptingMethod*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                    argc: uint32; retval: ptr VALUE): int32 {.cdecl.}
    SciterCallScriptingFunction*: proc (he: HELEMENT; name: cstring; argv: ptr VALUE;
                                    argc: uint32; retval: ptr VALUE): int32 {.cdecl.}
    SciterEvalElementScript*: proc (he: HELEMENT; script: WideCString;
                                scriptLength: uint32; retval: ptr VALUE): int32 {.
        cdecl.}
    SciterAttachHwndToElement*: proc (he: HELEMENT; hwnd: HWINDOW): int32 {.cdecl.}
    SciterControlGetType*: proc (he: HELEMENT; pType: ptr uint32): int32 {.cdecl.} ## #CTL_TYPE
    SciterGetValue*: proc (he: HELEMENT; pval: ptr VALUE): int32 {.cdecl.}
    SciterSetValue*: proc (he: HELEMENT; pval: ptr VALUE): int32 {.cdecl.}
    SciterGetExpando*: proc (he: HELEMENT; pval: ptr VALUE; forceCreation: bool): int32 {.
        cdecl.}
    SciterGetObject*: proc (he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): int32 {.
        cdecl.}
    SciterGetElementNamespace*: proc (he: HELEMENT; pval: ptr tiscript_value): int32 {.
        cdecl.}
    SciterGetHighlightedElement*: proc (hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.cdecl.}
    SciterSetHighlightedElement*: proc (hwnd: HWINDOW; he: HELEMENT): int32 {.cdecl.} ## #|
                                                                            ## #| DOM Node API
                                                                            ## #|
    SciterNodeAddRef*: proc (hn: HNODE): int32 {.cdecl.}
    SciterNodeRelease*: proc (hn: HNODE): int32 {.cdecl.}
    SciterNodeCastFromElement*: proc (he: HELEMENT; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodeCastToElement*: proc (hn: HNODE; he: ptr HELEMENT): int32 {.cdecl.}
    SciterNodeFirstChild*: proc (hn: HNODE; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodeLastChild*: proc (hn: HNODE; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodeNextSibling*: proc (hn: HNODE; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodePrevSibling*: proc (hn: HNODE; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodeParent*: proc (hnode: HNODE; pheParent: ptr HELEMENT): int32 {.cdecl.}
    SciterNodeNthChild*: proc (hnode: HNODE; n: uint32; phn: ptr HNODE): int32 {.cdecl.}
    SciterNodeChildrenCount*: proc (hnode: HNODE; pn: ptr uint32): int32 {.cdecl.}
    SciterNodeType*: proc (hnode: HNODE; pNodeType: ptr uint32): int32 {.cdecl.} ## #NODE_TYPE
    SciterNodeGetText*: proc (hnode: HNODE; rcv: LPCWSTR_RECEIVER;
                            rcv_param: pointer): int32 {.cdecl.}
    SciterNodeSetText*: proc (hnode: HNODE; text: WideCString; textLength: uint32): int32 {.
        cdecl.}
    SciterNodeInsert*: proc (hnode: HNODE; where: uint32; ## #NODE_INS_TARGET
                            what: HNODE): int32 {.cdecl.}
    SciterNodeRemove*: proc (hnode: HNODE; finalize: bool): int32 {.cdecl.}
    SciterCreateTextNode*: proc (text: WideCString; textLength: uint32;
                                phnode: ptr HNODE): int32 {.cdecl.}
    SciterCreateCommentNode*: proc (text: WideCString; textLength: uint32;
                                phnode: ptr HNODE): int32 {.cdecl.} ## #|
                                                                ## #| Value API
                                                                ## #|
    ValueInit*: proc (pval: ptr VALUE): uint32 {.cdecl.}
    ValueClear*: proc (pval: ptr VALUE): uint32 {.cdecl.}
    ValueCompare*: proc (pval1: ptr VALUE; pval2: ptr VALUE): uint32 {.cdecl.}
    ValueCopy*: proc (pdst: ptr VALUE; psrc: ptr VALUE): uint32 {.cdecl.}
    ValueIsolate*: proc (pdst: ptr VALUE): uint32 {.cdecl.}
    ValueType*: proc (pval: ptr VALUE; pType: ptr uint32; pUnits: ptr uint32): uint32 {.
        cdecl.}
    ValueStringData*: proc (pval: ptr VALUE; pChars: ptr WideCString;
                        pNumChars: ptr uint32): uint32 {.cdecl.}
    ValueStringDataSet*: proc (pval: ptr VALUE; chars: WideCString; numChars: uint32;
                            units: uint32): uint32 {.cdecl.}
    ValueIntData*: proc (pval: ptr VALUE; pData: ptr int32): uint32 {.cdecl.}
    ValueIntDataSet*: proc (pval: ptr VALUE; data: int32; `type`: uint32; units: uint32): uint32 {.
        cdecl.}
    ValueInt64Data*: proc (pval: ptr VALUE; pData: ptr int64): uint32 {.cdecl.}
    ValueInt64DataSet*: proc (pval: ptr VALUE; data: int64; `type`: uint32; units: uint32): uint32 {.
        cdecl.}
    ValueFloatData*: proc (pval: ptr VALUE; pData: ptr float64): uint32 {.cdecl.}
    ValueFloatDataSet*: proc (pval: ptr VALUE; data: float64; `type`: uint32;
                            units: uint32): uint32 {.cdecl.}
    ValueBinaryData*: proc (pval: ptr VALUE; pBytes: ptr pointer; pnBytes: ptr uint32): uint32 {.
        cdecl.}
    ValueBinaryDataSet*: proc (pval: ptr VALUE; pBytes: pointer; nBytes: uint32;
                            `type`: uint32; units: uint32): uint32 {.cdecl.}
    ValueElementsCount*: proc (pval: ptr VALUE; pn: ptr int32): uint32 {.cdecl.}
    ValueNthElementValue*: proc (pval: ptr VALUE; n: int32; pretval: ptr VALUE): uint32 {.
        cdecl.}
    ValueNthElementValueSet*: proc (pval: ptr VALUE; n: int32; pval_to_set: ptr VALUE): uint32 {.
        cdecl.}
    ValueNthElementKey*: proc (pval: ptr VALUE; n: int32; pretval: ptr VALUE): uint32 {.
        cdecl.}
    ValueEnumElements*: proc (pval: ptr VALUE; penum: KeyValueCallback;
                            param: pointer): uint32 {.cdecl.}
    ValueSetValueToKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): uint32 {.
        cdecl.}
    ValueGetValueOfKey*: proc (pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): uint32 {.
        cdecl.}
    ValueToString*: proc (pval: ptr VALUE; how: uint32): uint32 {.cdecl.} ## #VALUE_STRING_CVT_TYPE
    ValueFromString*: proc (pval: ptr VALUE; str: WideCString; strLength: uint32;
                        how: uint32): uint32 {.cdecl.} ## #VALUE_STRING_CVT_TYPE
    ValueInvoke*: proc (pval: ptr VALUE; pthis: ptr VALUE; argc: uint32; argv: ptr VALUE;
                    pretval: ptr VALUE; url: WideCString): uint32 {.cdecl.}
    ValueNativeFunctorSet*: proc (pval: ptr VALUE;
                                pinvoke: NATIVE_FUNCTOR_INVOKE;
                                prelease: NATIVE_FUNCTOR_RELEASE; tag: pointer): uint32 {.
        cdecl.}
    ValueIsNativeFunctor*: proc (pval: ptr VALUE): bool {.cdecl.} ## # tiscript VM API
    TIScriptAPI*: proc (): ptr tiscript_native_interface {.cdecl.}
    SciterGetVM*: proc (hwnd: HWINDOW): HVM {.cdecl.}
    Sciter_tv2V*: proc (vm: HVM; script_value: tiscript_value; value: ptr VALUE;
                    isolate: bool): bool {.cdecl.}
    Sciter_V2tv*: proc (vm: HVM; valuev: ptr VALUE; script_value: ptr tiscript_value): bool {.
        cdecl.}
    SciterOpenArchive*: proc (archiveData: pointer; archiveDataLength: uint32): HSARCHIVE {.
        cdecl.}
    SciterGetArchiveItem*: proc (harc: HSARCHIVE; path: WideCString;
                                pdata: ptr pointer; pdataLength: ptr uint32): bool {.
        cdecl.}
    SciterCloseArchive*: proc (harc: HSARCHIVE): bool {.cdecl.}
    SciterFireEvent*: proc (evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool;
                        handled: ptr bool): int32 {.cdecl.}
    SciterGetCallbackParam*: proc (hwnd: HWINDOW): pointer {.cdecl.}
    SciterPostCallback*: proc (hwnd: HWINDOW; wparam: uint32; lparam: uint32;
                            timeoutms: uint32): uint32 {.cdecl.}
    GetSciterGraphicsAPI*: proc (): LPSciterGraphicsAPI {.cdecl.}
    GetSciterRequestAPI*: proc (): LPSciterRequestAPI {.cdecl.}
    when defined(windows):
    SciterCreateOnDirectXWindow*: proc (hwnd:HWINDOW, pSwapChain:pointer): bool {.cdecl.}
    SciterRenderOnDirectXWindow*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, frontLayer:bool): bool {.cdecl.}
    SciterRenderOnDirectXTexture*: proc (hwnd:HWINDOW, elementToRenderOrNull:HELEMENT, surface:pointer): bool {.cdecl.}
    for_c2nim_only_very_bad_patch_so_do_not_pay_attention_to_this_field*: bool ## #
                                                                            ## c2nim
                                                                            ## needs
                                                                            ## this :(

  SciterAPI_ptr* = proc (): ptr ISciterAPI {.cdecl.}

include loader
## # defining "official" API functions:

proc SciterClassName*(): WideCString {.inline, discardable, cdecl.} =
  return SAPI().SciterClassName()

proc SciterVersion*(major: bool): uint32 {.inline, discardable, cdecl.} =
  return SAPI().SciterVersion(major)

proc SciterDataReady*(hwnd: HWINDOW; uri: WideCString; data: pointer;
                    dataLength: uint32): bool {.inline, discardable, cdecl.} =
  return SAPI().SciterDataReady(hwnd, uri, data, dataLength)

proc SciterDataReadyAsync*(hwnd: HWINDOW; uri: WideCString; data: pointer;
                        dataLength: uint32; requestId: pointer): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterDataReadyAsync(hwnd, uri, data, dataLength, requestId)

when defined(windows):
  proc SciterProc*(hwnd: HWINDOW; msg: uint32; wParam: WPARAM; lParam: LPARAM): LRESULT {.
    inline, discardable, cdecl.} =
    return SAPI().SciterProc(hwnd, msg, wParam, lParam)

  proc SciterProcND*(hwnd: HWINDOW; msg: uint32; wParam: WPARAM; lParam: LPARAM;
                    pbHandled: ptr bool): LRESULT {.inline, discardable, cdecl.} =
    return SAPI().SciterProcND(hwnd, msg, wParam, lParam, pbHandled)

proc SciterLoadFile*(hWndSciter: HWINDOW; filename: WideCString): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterLoadFile(hWndSciter, filename)

proc SciterLoadHtml*(hWndSciter: HWINDOW; html: pointer; htmlSize: uint32;
                    baseUrl: WideCString): bool {.inline, discardable, cdecl.} =
  return SAPI().SciterLoadHtml(hWndSciter, html, htmlSize, baseUrl)

proc SciterSetCallback*(hWndSciter: HWINDOW; cb: SciterHostCallback; cbParam: pointer) {.
    inline, cdecl.} =
  SAPI().SciterSetCallback(hWndSciter, cb, cbParam)

proc SciterSetMasterCSS*(utf8: pointer; numBytes: uint32): bool {.inline, discardable,
    cdecl.} =
  return SAPI().SciterSetMasterCSS(utf8, numBytes)

proc SciterAppendMasterCSS*(utf8: pointer; numBytes: uint32): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterAppendMasterCSS(utf8, numBytes)

proc SciterSetCSS*(hWndSciter: HWINDOW; utf8: pointer; numBytes: uint32;
                baseUrl: WideCString; mediaType: WideCString): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetCSS(hWndSciter, utf8, numBytes, baseUrl, mediaType)

proc SciterSetMediaType*(hWndSciter: HWINDOW; mediaType: WideCString): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetMediaType(hWndSciter, mediaType)

proc SciterSetMediaVars*(hWndSciter: HWINDOW; mediaVars: ptr Value): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetMediaVars(hWndSciter, mediaVars)

proc SciterGetMinWidth*(hWndSciter: HWINDOW): uint32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetMinWidth(hWndSciter)

proc SciterGetMinHeight*(hWndSciter: HWINDOW; width: uint32): uint32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetMinHeight(hWndSciter, width)

proc SciterCall*(hWnd: HWINDOW; functionName: cstring; argc: uint32; argv: ptr Value;
                retval: ptr Value): bool {.inline, discardable, cdecl.} =
  return SAPI().SciterCall(hWnd, functionName, argc, argv, retval)

proc SciterEval*(hwnd: HWINDOW; script: WideCString; scriptLength: uint32;
                pretval: ptr Value): bool {.inline, discardable, cdecl.} =
  return SAPI().SciterEval(hwnd, script, scriptLength, pretval)

proc SciterUpdateWindow*(hwnd: HWINDOW) {.inline, cdecl.} =
  SAPI().SciterUpdateWindow(hwnd)

when defined(windows):
  proc SciterTranslateMessage*(lpMsg: ptr MSG): bool {.inline, discardable, cdecl.} =
    return SAPI().SciterTranslateMessage(lpMsg)

proc SciterSetOption*(hWnd: HWINDOW; option: uint32; value: uint32): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetOption(hWnd, option, value)

proc SciterGetPPI*(hWndSciter: HWINDOW; px: ptr uint32; py: ptr uint32) {.inline, cdecl.} =
  SAPI().SciterGetPPI(hWndSciter, px, py)

proc SciterGetViewExpando*(hwnd: HWINDOW; pval: ptr VALUE): bool {.inline, discardable,
    cdecl.} =
  return SAPI().SciterGetViewExpando(hwnd, pval)

when defined(windows):
  proc SciterRenderD2D*(hWndSciter: HWINDOW; prt: pointer): bool {.inline, discardable,
    cdecl.} =
    return SAPI().SciterRenderD2D(hWndSciter, prt)

  proc SciterD2DFactory*(ppf: pointer): bool {.inline, discardable, cdecl.} =
    return SAPI().SciterD2DFactory(ppf)

  proc SciterDWFactory*(ppf: pointer): bool {.inline, discardable, cdecl.} =
    return SAPI().SciterDWFactory(ppf)

proc SciterGraphicsCaps*(pcaps: ptr uint32): bool {.inline, discardable, cdecl.} =
  return SAPI().SciterGraphicsCaps(pcaps)

proc SciterSetHomeURL*(hWndSciter: HWINDOW; baseUrl: WideCString): bool {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetHomeURL(hWndSciter, baseUrl)

when defined(osx):
  proc SciterCreateNSView*(frame: ptr Rect): HWINDOW {.inline, discardable, cdecl.} =
    return SAPI().SciterCreateNSView(frame)

proc SciterCreateWindow*(creationFlags: uint32; frame: ptr Rect;
                        delegate: SciterWindowDelegate; delegateParam: pointer;
                        parent: HWINDOW): HWINDOW {.inline, discardable, cdecl.} =
  return SAPI().SciterCreateWindow(creationFlags, frame, delegate, delegateParam,
                                parent)

proc Sciter_UseElement*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().Sciter_UseElement(he)

proc Sciter_UnuseElement*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().Sciter_UnuseElement(he)

proc SciterGetRootElement*(hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetRootElement(hwnd, phe)

proc SciterGetFocusElement*(hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetFocusElement(hwnd, phe)

proc SciterFindElement*(hwnd: HWINDOW; pt: Point; phe: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterFindElement(hwnd, pt, phe)

proc SciterGetChildrenCount*(he: HELEMENT; count: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetChildrenCount(he, count)

proc SciterGetNthChild*(he: HELEMENT; n: uint32; phe: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetNthChild(he, n, phe)

proc SciterGetParentElement*(he: HELEMENT; p_parent_he: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetParentElement(he, p_parent_he)

proc SciterGetElementHtmlCB*(he: HELEMENT; outer: bool; rcv: LPCBYTE_RECEIVER;
                            rcv_param: pointer): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetElementHtmlCB(he, outer, rcv, rcv_param)

proc SciterGetElementTextCB*(he: HELEMENT; rcv: LPCWSTR_RECEIVER;
                            rcv_param: pointer): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetElementTextCB(he, rcv, rcv_param)

proc SciterSetElementText*(he: HELEMENT; utf16: WideCString; length: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSetElementText(he, utf16, length)

proc SciterGetAttributeCount*(he: HELEMENT; p_count: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetAttributeCount(he, p_count)

proc SciterGetNthAttributeNameCB*(he: HELEMENT; n: uint32; rcv: LPCSTR_RECEIVER;
                                rcv_param: pointer): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterGetNthAttributeNameCB(he, n, rcv, rcv_param)

proc SciterGetNthAttributeValueCB*(he: HELEMENT; n: uint32;
                                rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetNthAttributeValueCB(he, n, rcv, rcv_param)

proc SciterGetAttributeByNameCB*(he: HELEMENT; name: cstring;
                                rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetAttributeByNameCB(he, name, rcv, rcv_param)

proc SciterSetAttributeByName*(he: HELEMENT; name: cstring; value: WideCString): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSetAttributeByName(he, name, value)

proc SciterClearAttributes*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterClearAttributes(he)

proc SciterGetElementIndex*(he: HELEMENT; p_index: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetElementIndex(he, p_index)

proc SciterGetElementType*(he: HELEMENT; p_type: ptr cstring): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetElementType(he, p_type)

proc SciterGetElementTypeCB*(he: HELEMENT; rcv: LPCSTR_RECEIVER;
                            rcv_param: pointer): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetElementTypeCB(he, rcv, rcv_param)

proc SciterGetStyleAttributeCB*(he: HELEMENT; name: cstring;
                                rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetStyleAttributeCB(he, name, rcv, rcv_param)

proc SciterSetStyleAttribute*(he: HELEMENT; name: cstring; value: WideCString): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSetStyleAttribute(he, name, value)

proc SciterGetElementLocation*(he: HELEMENT; p_location: ptr Rect; areas: uint32): int32 {.
    inline, discardable, cdecl.} =
  ## #ELEMENT_AREAS
  return SAPI().SciterGetElementLocation(he, p_location, areas)

proc SciterScrollToView*(he: HELEMENT; SciterScrollFlags: uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterScrollToView(he, SciterScrollFlags)

proc SciterUpdateElement*(he: HELEMENT; andForceRender: bool): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterUpdateElement(he, andForceRender)

proc SciterRefreshElementArea*(he: HELEMENT; rc: Rect): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterRefreshElementArea(he, rc)

proc SciterSetCapture*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterSetCapture(he)

proc SciterReleaseCapture*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterReleaseCapture(he)

proc SciterGetElementHwnd*(he: HELEMENT; p_hwnd: ptr HWINDOW; rootWindow: bool): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetElementHwnd(he, p_hwnd, rootWindow)

proc SciterCombineURL*(he: HELEMENT; szUrlBuffer: WideCString; UrlBufferSize: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterCombineURL(he, szUrlBuffer, UrlBufferSize)

proc SciterSelectElements*(he: HELEMENT; CSS_selectors: cstring;
                        callback: SciterElementCallback; param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSelectElements(he, CSS_selectors, callback, param)

proc SciterSelectElementsW*(he: HELEMENT; CSS_selectors: WideCString;
                            callback: SciterElementCallback; param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSelectElementsW(he, CSS_selectors, callback, param)

proc SciterSelectParent*(he: HELEMENT; selector: cstring; depth: uint32;
                        heFound: ptr HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterSelectParent(he, selector, depth, heFound)

proc SciterSelectParentW*(he: HELEMENT; selector: WideCString; depth: uint32;
                        heFound: ptr HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterSelectParentW(he, selector, depth, heFound)

proc SciterSetElementHtml*(he: HELEMENT; html: ptr byte; htmlLength: uint32;
                        where: uint32): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterSetElementHtml(he, html, htmlLength, where)

proc SciterGetElementUID*(he: HELEMENT; puid: ptr uint32): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterGetElementUID(he, puid)

proc SciterGetElementByUID*(hwnd: HWINDOW; uid: uint32; phe: ptr HELEMENT): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetElementByUID(hwnd, uid, phe)

proc SciterShowPopup*(hePopup: HELEMENT; heAnchor: HELEMENT; placement: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterShowPopup(hePopup, heAnchor, placement)

proc SciterShowPopupAt*(hePopup: HELEMENT; pos: Point; animate: bool): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterShowPopupAt(hePopup, pos, animate)

proc SciterHidePopup*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterHidePopup(he)

proc SciterGetElementState*(he: HELEMENT; pstateBits: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetElementState(he, pstateBits)

proc SciterSetElementState*(he: HELEMENT; stateBitsToSet: uint32;
                            stateBitsToClear: uint32; updateView: bool): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSetElementState(he, stateBitsToSet, stateBitsToClear,
                                    updateView)

proc SciterCreateElement*(tagname: cstring; textOrNull: WideCString;
                        phe: ptr HELEMENT): int32 {.inline, discardable, cdecl.} =
  ## #out
  return SAPI().SciterCreateElement(tagname, textOrNull, phe)

proc SciterCloneElement*(he: HELEMENT; phe: ptr HELEMENT): int32 {.inline, discardable,
    cdecl.} =
  ## #out
  return SAPI().SciterCloneElement(he, phe)

proc SciterInsertElement*(he: HELEMENT; hparent: HELEMENT; index: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterInsertElement(he, hparent, index)

proc SciterDetachElement*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterDetachElement(he)

proc SciterDeleteElement*(he: HELEMENT): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterDeleteElement(he)

proc SciterSetTimer*(he: HELEMENT; milliseconds: uint32; timer_id: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSetTimer(he, milliseconds, timer_id)

proc SciterDetachEventHandler*(he: HELEMENT; pep: ElementEventProc; tag: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterDetachEventHandler(he, pep, tag)

proc SciterAttachEventHandler*(he: HELEMENT; pep: ElementEventProc; tag: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterAttachEventHandler(he, pep, tag)

proc SciterWindowAttachEventHandler*(hwndLayout: HWINDOW; pep: ElementEventProc;
                                    tag: pointer; subscription: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterWindowAttachEventHandler(hwndLayout, pep, tag, subscription)

proc SciterWindowDetachEventHandler*(hwndLayout: HWINDOW; pep: ElementEventProc;
                                    tag: pointer): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterWindowDetachEventHandler(hwndLayout, pep, tag)

proc SciterSendEvent*(he: HELEMENT; appEventCode: uint32; heSource: HELEMENT;
                    reason: uint32; handled: ptr bool): int32 {.inline, discardable,
    cdecl.} =
  ## #out
  return SAPI().SciterSendEvent(he, appEventCode, heSource, reason, handled)

proc SciterPostEvent*(he: HELEMENT; appEventCode: uint32; heSource: HELEMENT;
                    reason: uint32): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterPostEvent(he, appEventCode, heSource, reason)

proc SciterFireEvent*(evt: ptr BEHAVIOR_EVENT_PARAMS; post: bool; handled: ptr bool): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterFireEvent(evt, post, handled)

proc SciterCallBehaviorMethod*(he: HELEMENT; params: ptr METHOD_PARAMS): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterCallBehaviorMethod(he, params)

proc SciterRequestElementData*(he: HELEMENT; url: WideCString; dataType: uint32;
                            initiator: HELEMENT): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterRequestElementData(he, url, dataType, initiator)

proc SciterHttpRequest*(he: HELEMENT; url: WideCString; dataType: uint32;
                        requestType: uint32; requestParams: ptr REQUEST_PARAM;
                        nParams: uint32): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterHttpRequest(he, url, dataType, requestType, requestParams,
                                nParams)

proc SciterGetScrollInfo*(he: HELEMENT; scrollPos: ptr Point; viewRect: ptr Rect;
                        contentSize: ptr Size): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetScrollInfo(he, scrollPos, viewRect, contentSize)

proc SciterSetScrollPos*(he: HELEMENT; scrollPos: Point; smooth: bool): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetScrollPos(he, scrollPos, smooth)

proc SciterGetElementIntrinsicWidths*(he: HELEMENT; pMinWidth: ptr int32;
                                    pMaxWidth: ptr int32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetElementIntrinsicWidths(he, pMinWidth, pMaxWidth)

proc SciterGetElementIntrinsicHeight*(he: HELEMENT; forWidth: int32;
                                    pHeight: ptr int32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetElementIntrinsicHeight(he, forWidth, pHeight)

proc SciterIsElementVisible*(he: HELEMENT; pVisible: ptr bool): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterIsElementVisible(he, pVisible)

proc SciterIsElementEnabled*(he: HELEMENT; pEnabled: ptr bool): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterIsElementEnabled(he, pEnabled)

proc SciterSortElements*(he: HELEMENT; firstIndex: uint32; lastIndex: uint32;
                        cmpFunc: ptr ELEMENT_COMPARATOR; cmpFuncParam: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterSortElements(he, firstIndex, lastIndex, cmpFunc, cmpFuncParam)

proc SciterSwapElements*(he1: HELEMENT; he2: HELEMENT): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterSwapElements(he1, he2)

proc SciterTraverseUIEvent*(evt: uint32; eventCtlStruct: pointer;
                            bOutProcessed: ptr bool): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterTraverseUIEvent(evt, eventCtlStruct, bOutProcessed)

proc SciterCallScriptingMethod*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                                argc: uint32; retval: ptr VALUE): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterCallScriptingMethod(he, name, argv, argc, retval)

proc SciterCallScriptingFunction*(he: HELEMENT; name: cstring; argv: ptr VALUE;
                                argc: uint32; retval: ptr VALUE): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterCallScriptingFunction(he, name, argv, argc, retval)

proc SciterEvalElementScript*(he: HELEMENT; script: WideCString;
                            scriptLength: uint32; retval: ptr VALUE): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterEvalElementScript(he, script, scriptLength, retval)

proc SciterAttachHwndToElement*(he: HELEMENT; hwnd: HWINDOW): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterAttachHwndToElement(he, hwnd)

proc SciterControlGetType*(he: HELEMENT; pType: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  ## #CTL_TYPE
  return SAPI().SciterControlGetType(he, pType)

proc SciterGetValue*(he: HELEMENT; pval: ptr VALUE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterGetValue(he, pval)

proc SciterSetValue*(he: HELEMENT; pval: ptr VALUE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterSetValue(he, pval)

proc SciterGetExpando*(he: HELEMENT; pval: ptr VALUE; forceCreation: bool): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetExpando(he, pval, forceCreation)

proc SciterGetObject*(he: HELEMENT; pval: ptr tiscript_value; forceCreation: bool): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetObject(he, pval, forceCreation)

proc SciterGetElementNamespace*(he: HELEMENT; pval: ptr tiscript_value): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterGetElementNamespace(he, pval)

proc SciterGetHighlightedElement*(hwnd: HWINDOW; phe: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterGetHighlightedElement(hwnd, phe)

proc SciterSetHighlightedElement*(hwnd: HWINDOW; he: HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterSetHighlightedElement(hwnd, he)

proc SciterNodeAddRef*(hn: HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeAddRef(hn)

proc SciterNodeRelease*(hn: HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeRelease(hn)

proc SciterNodeCastFromElement*(he: HELEMENT; phn: ptr HNODE): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterNodeCastFromElement(he, phn)

proc SciterNodeCastToElement*(hn: HNODE; he: ptr HELEMENT): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterNodeCastToElement(hn, he)

proc SciterNodeFirstChild*(hn: HNODE; phn: ptr HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeFirstChild(hn, phn)

proc SciterNodeLastChild*(hn: HNODE; phn: ptr HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeLastChild(hn, phn)

proc SciterNodeNextSibling*(hn: HNODE; phn: ptr HNODE): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterNodeNextSibling(hn, phn)

proc SciterNodePrevSibling*(hn: HNODE; phn: ptr HNODE): int32 {.inline, discardable,
    cdecl.} =
  return SAPI().SciterNodePrevSibling(hn, phn)

proc SciterNodeParent*(hnode: HNODE; pheParent: ptr HELEMENT): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterNodeParent(hnode, pheParent)

proc SciterNodeNthChild*(hnode: HNODE; n: uint32; phn: ptr HNODE): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterNodeNthChild(hnode, n, phn)

proc SciterNodeChildrenCount*(hnode: HNODE; pn: ptr uint32): int32 {.inline,
    discardable, cdecl.} =
  return SAPI().SciterNodeChildrenCount(hnode, pn)

proc SciterNodeType*(hnode: HNODE; pNodeType: ptr uint32): int32 {.inline, discardable,
    cdecl.} =
  ## #NODE_TYPE
  return SAPI().SciterNodeType(hnode, pNodeType)

proc SciterNodeGetText*(hnode: HNODE; rcv: LPCWSTR_RECEIVER; rcv_param: pointer): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterNodeGetText(hnode, rcv, rcv_param)

proc SciterNodeSetText*(hnode: HNODE; text: WideCString; textLength: uint32): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterNodeSetText(hnode, text, textLength)

proc SciterNodeInsert*(hnode: HNODE; where: uint32; ## #NODE_INS_TARGET
                    what: HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeInsert(hnode, where, what)

proc SciterNodeRemove*(hnode: HNODE; finalize: bool): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterNodeRemove(hnode, finalize)

proc SciterCreateTextNode*(text: WideCString; textLength: uint32; phnode: ptr HNODE): int32 {.
    inline, discardable, cdecl.} =
  return SAPI().SciterCreateTextNode(text, textLength, phnode)

proc SciterCreateCommentNode*(text: WideCString; textLength: uint32;
                            phnode: ptr HNODE): int32 {.inline, discardable, cdecl.} =
  return SAPI().SciterCreateCommentNode(text, textLength, phnode)

proc SciterGetVM*(hwnd: HWINDOW): HVM {.inline, discardable, cdecl.} =
  return SAPI().SciterGetVM(hwnd)

proc ValueInit*(pval: ptr VALUE): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueInit(pval)

proc ValueClear*(pval: ptr VALUE): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueClear(pval)

proc ValueCompare*(pval1: ptr VALUE; pval2: ptr VALUE): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueCompare(pval1, pval2)

proc ValueCopy*(pdst: ptr VALUE; psrc: ptr VALUE): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueCopy(pdst, psrc)

proc ValueIsolate*(pdst: ptr VALUE): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueIsolate(pdst)

proc ValueType*(pval: ptr VALUE; pType: ptr uint32; pUnits: ptr uint32): uint32 {.inline,
    discardable, cdecl.} =
  return SAPI().ValueType(pval, pType, pUnits)

proc ValueStringData*(pval: ptr VALUE; pChars: ptr WideCString; pNumChars: ptr uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueStringData(pval, pChars, pNumChars)

proc ValueStringDataSet*(pval: ptr VALUE; chars: WideCString; numChars: uint32;
                        units: uint32): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueStringDataSet(pval, chars, numChars, units)

proc ValueIntData*(pval: ptr VALUE; pData: ptr int32): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueIntData(pval, pData)

proc ValueIntDataSet*(pval: ptr VALUE; data: int32; `type`: uint32; units: uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueIntDataSet(pval, data, `type`, units)

proc ValueInt64Data*(pval: ptr VALUE; pData: ptr int64): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueInt64Data(pval, pData)

proc ValueInt64DataSet*(pval: ptr VALUE; data: int64; `type`: uint32; units: uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueInt64DataSet(pval, data, `type`, units)

proc ValueFloatData*(pval: ptr VALUE; pData: ptr float64): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueFloatData(pval, pData)

proc ValueFloatDataSet*(pval: ptr VALUE; data: float64; `type`: uint32; units: uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueFloatDataSet(pval, data, `type`, units)

proc ValueBinaryData*(pval: ptr VALUE; pBytes: ptr pointer; pnBytes: ptr uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueBinaryData(pval, pBytes, pnBytes)

proc ValueBinaryDataSet*(pval: ptr VALUE; pBytes: pointer; nBytes: uint32;
                        `type`: uint32; units: uint32): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueBinaryDataSet(pval, pBytes, nBytes, `type`, units)

proc ValueElementsCount*(pval: ptr VALUE; pn: ptr int32): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueElementsCount(pval, pn)

proc ValueNthElementValue*(pval: ptr VALUE; n: int32; pretval: ptr VALUE): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueNthElementValue(pval, n, pretval)

proc ValueNthElementValueSet*(pval: ptr VALUE; n: int32; pval_to_set: ptr VALUE): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueNthElementValueSet(pval, n, pval_to_set)

proc ValueNthElementKey*(pval: ptr VALUE; n: int32; pretval: ptr VALUE): uint32 {.inline,
    discardable, cdecl.} =
  return SAPI().ValueNthElementKey(pval, n, pretval)

proc ValueEnumElements*(pval: ptr VALUE; penum: KeyValueCallback; param: pointer): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueEnumElements(pval, penum, param)

proc ValueSetValueToKey*(pval: ptr VALUE; pkey: ptr VALUE; pval_to_set: ptr VALUE): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueSetValueToKey(pval, pkey, pval_to_set)

proc ValueGetValueOfKey*(pval: ptr VALUE; pkey: ptr VALUE; pretval: ptr VALUE): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueGetValueOfKey(pval, pkey, pretval)

proc ValueToString*(pval: ptr VALUE; how: uint32): uint32 {.inline, discardable, cdecl.} =
  return SAPI().ValueToString(pval, how)

proc ValueFromString*(pval: ptr VALUE; str: WideCString; strLength: uint32; how: uint32): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueFromString(pval, str, strLength, how)

proc ValueInvoke*(pval: ptr VALUE; pthis: ptr VALUE; argc: uint32; argv: ptr VALUE;
                pretval: ptr VALUE; url: WideCString): uint32 {.inline, discardable,
    cdecl.} =
  return SAPI().ValueInvoke(pval, pthis, argc, argv, pretval, url)

proc ValueNativeFunctorSet*(pval: ptr VALUE; pinvoke: NATIVE_FUNCTOR_INVOKE;
                            prelease: NATIVE_FUNCTOR_RELEASE; tag: pointer): uint32 {.
    inline, discardable, cdecl.} =
  return SAPI().ValueNativeFunctorSet(pval, pinvoke, prelease, tag)

proc ValueIsNativeFunctor*(pval: ptr VALUE): bool {.inline, discardable, cdecl.} =
  return SAPI().ValueIsNativeFunctor(pval)

## # conversion between script (managed) value and the VALUE ( com::variant alike thing )

proc Sciter_tv2V*(vm: HVM; script_value: tiscript_value; out_value: ptr VALUE;
                isolate: bool): bool {.inline, discardable, cdecl.} =
  return SAPI().Sciter_tv2V(vm, script_value, out_value, isolate)

proc Sciter_V2tv*(vm: HVM; value: ptr VALUE; out_script_value: ptr tiscript_value): bool {.
    inline, discardable, cdecl.} =
  return SAPI().Sciter_V2tv(vm, value, out_script_value)

when defined(windows):
  proc SciterCreateOnDirectXWindow*(hwnd: HWINDOW; pSwapChain: pointer): bool {.
    inline, discardable, cdecl.} =
    return SAPI().SciterCreateOnDirectXWindow(hwnd, pSwapChain)

  proc SciterRenderOnDirectXWindow*(hwnd: HWINDOW; elementToRenderOrNull: HELEMENT;
                                    frontLayer: bool): bool {.inline, discardable,
    cdecl.} =
    return SAPI().SciterRenderOnDirectXWindow(hwnd, elementToRenderOrNull,
        frontLayer)

  proc SciterRenderOnDirectXTexture*(hwnd: HWINDOW;
                                    elementToRenderOrNull: HELEMENT;
                                    surface: pointer): bool {.inline, discardable,
    cdecl.} =
    return SAPI().SciterRenderOnDirectXTexture(hwnd, elementToRenderOrNull, surface)
