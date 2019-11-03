/*
 * The Sciter Engine of Terra Informatica Software, Inc.
 * http://sciter.com
 *
 * The code and information provided "as-is" without
 * warranty of any kind, either expressed or implied.
 *
 * (C) 2003-2015, Terra Informatica Software, Inc.
 */

#ifndef __SCITER_X_DEF__
#define __SCITER_X_DEF__

#ifdef C2NIM
  #cdecl
  #skipinclude
  #def SCFN(name) (*name)
  #def SCAPI
  #def SC_CALLBACK
  #def TISAPI
  #def EXTAPI

  #prefix _

  #discardableprefix Sciter
  #discardableprefix Value

  #def UINT uint32
  #def INT int32
  #def UINT64 uint64
  #def INT64 int64
  #def BYTE byte
  #def LPCBYTE pointer
  #def WCHAR Utf16Char
  #def LPCWSTR  WideCString
  #def LPWSTR  WideCString
  #def CHAR char
  #def LPCSTR cstring
  #def VOID void
  #def UINT_PTR UINT
  #def BOOL bool
  #def double float64
  #def FLOAT_VALUE float64

  #def WINDOWS windows
  #def LINUX posix
  #def OSX osx

  #def SCITER_VALUE Value
  #def RECT Rect
  #def POINT Point
  #def SIZE Size
  #def LPVOID pointer
  #def LPCVOID pointer
  #def LPRECT Rect*
  #def LPCRECT Rect*
  #def PPOINT Point*
  #def LPPOINT Point*
  #def PSIZE Size*
  #def LPSIZE Size*
  #def LPUINT UINT*
  #def SCDOM_RESULT INT
#endif


#include "sciter-x-types.h"
#include "sciter-x-request.h"
#include "value.h"
#ifdef __cplusplus
  #include "aux-cvt.h"
  #include <iostream>
  #include <stdio.h>
  #include <stdarg.h>
  #include <wchar.h>
#endif

#ifndef C2NIM
  #define HAS_TISCRIPT

/** Resource data type.
 *  Used by SciterDataReadyAsync() function.
 **/

#define  HAS_TISCRIPT // in sciter
#endif

#include "sciter-x-value.h"
#include "sciter-x-dom.h"

/** #SC_LOAD_DATA notification return codes */
enum SC_LOAD_DATA_RETURN_CODES
{
  LOAD_OK = 0,      /**< do default loading if data not set */
  LOAD_DISCARD = 1, /**< discard request completely */
  LOAD_DELAYED = 2, /**< data will be delivered later by the host application.
                        Host application must call SciterDataReadyAsync(,,, requestId) on each LOAD_DELAYED request to avoid memory leaks. */
  LOAD_MYSELF  = 3, /**< you return LOAD_MYSELF result to indicate that your (the host) application took or will take care about HREQUEST in your code completely.
                        Use sciter-x-request.h[pp] API functions with SCN_LOAD_DATA::requestId handle . */
};

/**Notifies that Sciter is about to download a referred resource.
 *
 * \param lParam #LPSCN_LOAD_DATA.
 * \return #SC_LOAD_DATA_RETURN_CODES
 *
 * This notification gives application a chance to override built-in loader and
 * implement loading of resources in its own way (for example images can be loaded from
 * database or other resource). To do this set #SCN_LOAD_DATA::outData and
 * #SCN_LOAD_DATA::outDataSize members of SCN_LOAD_DATA. Sciter does not
 * store pointer to this data. You can call #SciterDataReady() function instead
 * of filling these fields. This allows you to free your outData buffer
 * immediately.
 **/
#define SC_LOAD_DATA       0x01

/**This notification indicates that external data (for example image) download process
 * completed.
 *
 * \param lParam #LPSCN_DATA_LOADED
 *
 * This notifiaction is sent for each external resource used by document when
 * this resource has been completely downloaded. Sciter will send this
 * notification asynchronously.
 **/
#define SC_DATA_LOADED     0x02

/**This notification is sent when all external data (for example image) has been downloaded.
 *
 * This notification is sent when all external resources required by document
 * have been completely downloaded. Sciter will send this notification
 * asynchronously.
 **/
/* obsolete #define SC_DOCUMENT_COMPLETE 0x03
  use DOCUMENT_COMPLETE DOM event.
 */


/**This notification is sent on parsing the document and while processing
 * elements having non empty style.behavior attribute value.
 *
 * \param lParam #LPSCN_ATTACH_BEHAVIOR
 *
 * Application has to provide implementation of #sciter::behavior interface.
 * Set #SCN_ATTACH_BEHAVIOR::impl to address of this implementation.
 **/
#define SC_ATTACH_BEHAVIOR 0x04

/**This notification is sent when instance of the engine is destroyed.
 * It is always final notification.
 *
 * \param lParam #LPSCN_ENGINE_DESTROYED
 *
 **/
#define SC_ENGINE_DESTROYED 0x05

/**Posted notification.

 * \param lParam #LPSCN_POSTED_NOTIFICATION
 *
 **/
#define SC_POSTED_NOTIFICATION 0x06


/**This notification is sent when the engine encounters critical rendering error: e.g. DirectX gfx driver error.
  Most probably bad gfx drivers.

 * \param lParam #LPSCN_GRAPHICS_CRITICAL_FAILURE
 *
 **/
#define SC_GRAPHICS_CRITICAL_FAILURE 0x07


/**Notification callback structure.
 **/
typedef struct SCITER_CALLBACK_NOTIFICATION
{
  UINT code; /**< [in] one of the codes above.*/
  HWINDOW hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
} SCITER_CALLBACK_NOTIFICATION;

typedef SCITER_CALLBACK_NOTIFICATION * LPSCITER_CALLBACK_NOTIFICATION;

typedef UINT SC_CALLBACK SciterHostCallback( LPSCITER_CALLBACK_NOTIFICATION pns, LPVOID callbackParam );

typedef SciterHostCallback * LPSciterHostCallback;


/**This structure is used by #SC_LOAD_DATA notification.
 *\copydoc SC_LOAD_DATA
 **/

typedef struct SCN_LOAD_DATA
{
    UINT code;                 /**< [in] one of the codes above.*/
    HWINDOW hwnd;              /**< [in] HWINDOW of the window this callback was attached to.*/

    LPCWSTR  uri;              /**< [in] Zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".*/

    LPCBYTE  outData;          /**< [in,out] pointer to loaded data to return. if data exists in the cache then this field contain pointer to it*/
    UINT     outDataSize;      /**< [in,out] loaded data size to return.*/
    UINT     dataType;         /**< [in] SciterResourceType */

    HREQUEST requestId;        /**< [in] request handle that can be used with sciter-x-request API */

    HELEMENT principal;
    HELEMENT initiator;
} SCN_LOAD_DATA;

typedef SCN_LOAD_DATA*  LPSCN_LOAD_DATA;

/**This structure is used by #SC_DATA_LOADED notification.
 *\copydoc SC_DATA_LOADED
 **/
typedef struct SCN_DATA_LOADED
{
    UINT code;                 /**< [in] one of the codes above.*/
    HWINDOW hwnd;              /**< [in] HWINDOW of the window this callback was attached to.*/

    LPCWSTR  uri;              /**< [in] zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".*/
    LPCBYTE  data;             /**< [in] pointer to loaded data.*/
    UINT     dataSize;         /**< [in] loaded data size (in bytes).*/
    UINT     dataType;         /**< [in] SciterResourceType */
    UINT     status;           /**< [in]
                                        status = 0 (dataSize == 0) - unknown error.
                                        status = 100..505 - http response status, Note: 200 - OK!
                                        status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
                                */
} SCN_DATA_LOADED;

typedef SCN_DATA_LOADED * LPSCN_DATA_LOADED;

/**This structure is used by #SC_ATTACH_BEHAVIOR notification.
 *\copydoc SC_ATTACH_BEHAVIOR **/
typedef struct SCN_ATTACH_BEHAVIOR
{
    UINT code;                        /**< [in] one of the codes above.*/
    HWINDOW hwnd;                     /**< [in] HWINDOW of the window this callback was attached to.*/

    HELEMENT element;                 /**< [in] target DOM element handle*/
    LPCSTR   behaviorName;            /**< [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.*/

    ElementEventProc* elementProc;    /**< [out] pointer to ElementEventProc function.*/
    LPVOID            elementTag;     /**< [out] tag value, passed as is into pointer ElementEventProc function.*/

} SCN_ATTACH_BEHAVIOR;
typedef SCN_ATTACH_BEHAVIOR* LPSCN_ATTACH_BEHAVIOR;

/**This structure is used by #SC_ENGINE_DESTROYED notification.
 *\copydoc SC_ENGINE_DESTROYED **/
typedef struct SCN_ENGINE_DESTROYED
{
    UINT code; /**< [in] one of the codes above.*/
    HWINDOW hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
} SCN_ENGINE_DESTROYED;

typedef SCN_ENGINE_DESTROYED* LPSCN_ENGINE_DESTROYED;

/**This structure is used by #SC_ENGINE_DESTROYED notification.
 *\copydoc SC_ENGINE_DESTROYED **/
typedef struct SCN_POSTED_NOTIFICATION
{
    UINT      code; /**< [in] one of the codes above.*/
    HWINDOW   hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
    UINT_PTR  wparam;
    UINT_PTR  lparam;
    UINT_PTR  lreturn;
} SCN_POSTED_NOTIFICATION;

typedef SCN_POSTED_NOTIFICATION* LPSCN_POSTED_NOTIFICATION;

/**This structure is used by #SC_GRAPHICS_CRITICAL_FAILURE notification.
 *\copydoc SC_GRAPHICS_CRITICAL_FAILURE **/
typedef struct SCN_GRAPHICS_CRITICAL_FAILURE
{
    UINT      code; /**< [in] = SC_GRAPHICS_CRITICAL_FAILURE */
    HWINDOW   hwnd; /**< [in] HWINDOW of the window this callback was attached to.*/
} SCN_GRAPHICS_CRITICAL_FAILURE;

typedef SCN_GRAPHICS_CRITICAL_FAILURE* LPSCN_GRAPHICS_CRITICAL_FAILURE;


#include "sciter-x-behavior.h"

enum SCRIPT_RUNTIME_FEATURES
{
  ALLOW_FILE_IO = 0x00000001,
  ALLOW_SOCKET_IO = 0x00000002,
  ALLOW_EVAL = 0x00000004,
  ALLOW_SYSINFO = 0x00000008
};

enum GFX_LAYER
{
  GFX_LAYER_GDI      = 1,
  GFX_LAYER_WARP     = 2,
  GFX_LAYER_D2D      = 3,
  GFX_LAYER_AUTO     = 0xFFFF,
};

enum SCITER_RT_OPTIONS
{
  SCITER_SMOOTH_SCROLL = 1,      // value:TRUE - enable, value:FALSE - disable, enabled by default
  SCITER_CONNECTION_TIMEOUT = 2, // value: milliseconds, connection timeout of http client
  SCITER_HTTPS_ERROR = 3,        // value: 0 - drop connection, 1 - use builtin dialog, 2 - accept connection silently
  SCITER_FONT_SMOOTHING = 4,     // value: 0 - system default, 1 - no smoothing, 2 - std smoothing, 3 - clear type

  SCITER_TRANSPARENT_WINDOW = 6, // Windows Aero support, value:
                                  // 0 - normal drawing,
                                  // 1 - window has transparent background after calls DwmExtendFrameIntoClientArea() or DwmEnableBlurBehindWindow().
  SCITER_SET_GPU_BLACKLIST  = 7, // hWnd = NULL,
                                  // value = LPCBYTE, json - GPU black list, see: gpu-blacklist.json resource.
  SCITER_SET_SCRIPT_RUNTIME_FEATURES = 8, // value - combination of SCRIPT_RUNTIME_FEATURES flags.
  SCITER_SET_GFX_LAYER = 9,      // hWnd = NULL, value - GFX_LAYER
  SCITER_SET_DEBUG_MODE = 10,    // hWnd, value - TRUE/FALSE
  SCITER_SET_UX_THEMING = 11,    // hWnd = NULL, value - BOOL, TRUE - the engine will use "unisex" theme that is common for all platforms.
                                  // That UX theme is not using OS primitives for rendering input elements. Use it if you want exactly
                                  // the same (modulo fonts) look-n-feel on all platforms.

  SCITER_ALPHA_WINDOW  = 12,     //  hWnd, value - TRUE/FALSE - window uses per pixel alpha (e.g. WS_EX_LAYERED/UpdateLayeredWindow() window)
};

typedef struct URL_DATA
{
  LPCSTR             requestedUrl;   // requested URL
  LPCSTR             realUrl;        // real URL data arrived from (after possible redirections)
  SciterResourceType requestedType;  // requested data category: html, script, image, etc.
  LPCSTR             httpHeaders;    // if any
  LPCSTR             mimeType;       // mime type reported by server (if any)
  LPCSTR             encoding;       // data encoding (if any)
  LPCBYTE            data;
  UINT              dataLength;
} URL_DATA;

typedef VOID SC_CALLBACK URL_DATA_RECEIVER( const URL_DATA* pUrlData, LPVOID param );

#if defined(OSX)
  typedef LPVOID SciterWindowDelegate; // Obj-C id, NSWindowDelegate and NSResponder
#elif defined(WINDOWS)
  typedef LRESULT SC_CALLBACK SciterWindowDelegate(HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam, LPVOID pParam, BOOL* handled);
#elif defined(LINUX)
  typedef LPVOID SciterWindowDelegate;
#endif

enum SCITER_CREATE_WINDOW_FLAGS {
  SW_CHILD      = (1 << 0), // child window only, if this flag is set all other flags ignored
  SW_TITLEBAR   = (1 << 1), // toplevel window, has titlebar
  SW_RESIZEABLE = (1 << 2), // has resizeable frame
  SW_TOOL       = (1 << 3), // is tool window
  SW_CONTROLS   = (1 << 4), // has minimize / maximize buttons
  SW_GLASSY     = (1 << 5), // glassy window ( DwmExtendFrameIntoClientArea on windows )
  SW_ALPHA      = (1 << 6), // transparent window ( e.g. WS_EX_LAYERED on Windows )
  SW_MAIN       = (1 << 7), // main window of the app, will terminate the app on close
  SW_POPUP      = (1 << 8), // the window is created as topmost window.
  SW_ENABLE_DEBUG = (1 << 9), // make this window inspector ready
  SW_OWNS_VM      = (1 << 10), // it has its own script VM
};


/** SciterSetupDebugOutput - setup debug output function.
 *
 *  This output function will be used for reprting problems
 *  found while loading html and css documents.
 *
 **/

enum OUTPUT_SUBSYTEMS
{
  OT_DOM = 0,       // html parser & runtime
  OT_CSSS,          // csss! parser & runtime
  OT_CSS,           // css parser
  OT_TIS,           // TIS parser & runtime
};
enum OUTPUT_SEVERITY
{
  OS_INFO,
  OS_WARNING,
  OS_ERROR,
};

typedef VOID (SC_CALLBACK* DEBUG_OUTPUT_PROC)(LPVOID param, UINT subsystem /*OUTPUT_SUBSYTEMS*/, UINT severity, LPCWSTR text, UINT text_length);

#endif
