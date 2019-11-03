/*
 * The Sciter Engine of Terra Informatica Software, Inc.
 * http://sciter.com
 *
 * The code and information provided "as-is" without
 * warranty of any kind, either expressed or implied.
 *
 * (C) 2003-2015, Terra Informatica Software, Inc.
 */

/*
 * DOM access methods, plain C interface
 */


#ifndef __sciter_dom_h__
#define __sciter_dom_h__

#ifdef C2NIM
  #stdcall
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

#include <assert.h>
#include <stdio.h> // for vsnprintf

#ifndef C2NIM
  #if defined(__cplusplus) && !defined( PLAIN_API_ONLY )
    namespace html
    {
      struct element;
      struct node;
    }
    namespace tool {
      class sar;
    }
    typedef html::element* HELEMENT;
    /**DOM node handle.*/
    typedef html::node* HNODE;
    /**DOM range handle.*/
    typedef void*  HRANGE;
    typedef struct hposition { HNODE hn; INT pos; } HPOSITION;
    typedef tool::sar* HSARCHIVE;
  #else
    /**DOM element handle.*/
    typedef void*  HELEMENT;
    /**DOM node handle.*/
    typedef void*  HNODE;
    /**DOM range handle.*/
    typedef void*  HRANGE;
    typedef void*  HSARCHIVE;
    typedef struct hposition { HNODE hn; INT pos; } HPOSITION;
  #endif
#else
  typedef void*  HELEMENT;
  /**DOM node handle.*/
  typedef void*  HNODE;
  /**DOM range handle.*/
  typedef void*  HRANGE;
  typedef void*  HSARCHIVE;
  typedef struct hposition { HNODE hn; INT pos; } HPOSITION;
#endif

//#include <string>
#include "tiscript.h"

#pragma warning(disable:4786) //identifier was truncated...
#pragma warning(disable:4100) //unreferenced formal parameter

#pragma once

/**Type of the result value for Sciter DOM functions.
 * Possible values are:
 * - \b SCDOM_OK - function completed successfully
 * - \b SCDOM_INVALID_HWND - invalid HWINDOW
 * - \b SCDOM_INVALID_HANDLE - invalid HELEMENT
 * - \b SCDOM_PASSIVE_HANDLE - attempt to use HELEMENT which is not marked by
 *   #Sciter_UseElement()
 * - \b SCDOM_INVALID_PARAMETER - parameter is invalid, e.g. pointer is null
 * - \b SCDOM_OPERATION_FAILED - operation failed, e.g. invalid html in
 *   #SciterSetElementHtml()
 **/

#define SCDOM_RESULT INT

#define SCDOM_OK 0
#define SCDOM_INVALID_HWND 1
#define SCDOM_INVALID_HANDLE 2
#define SCDOM_PASSIVE_HANDLE 3
#define SCDOM_INVALID_PARAMETER 4
#define SCDOM_OPERATION_FAILED 5
#define SCDOM_OK_NOT_HANDLED (-1)

  struct METHOD_PARAMS {
    UINT methodID;
  };
  struct REQUEST_PARAM {
    LPCWSTR name;
    LPCWSTR value;
  };

  typedef struct METHOD_PARAMS METHOD_PARAMS;
  typedef struct REQUEST_PARAM REQUEST_PARAM;

enum ELEMENT_AREAS
{
  ROOT_RELATIVE = 0x01,       // - or this flag if you want to get Sciter window relative coordinates,
                              //   otherwise it will use nearest windowed container e.g. popup window.
  SELF_RELATIVE = 0x02,       // - "or" this flag if you want to get coordinates relative to the origin
                              //   of element iself.
  CONTAINER_RELATIVE = 0x03,  // - position inside immediate container.
  VIEW_RELATIVE = 0x04,       // - position relative to view - Sciter window

  CONTENT_BOX = 0x00,   // content (inner)  box
  PADDING_BOX = 0x10,   // content + paddings
  BORDER_BOX  = 0x20,   // content + paddings + border
  MARGIN_BOX  = 0x30,   // content + paddings + border + margins

  BACK_IMAGE_AREA = 0x40, // relative to content origin - location of background image (if it set no-repeat)
  FORE_IMAGE_AREA = 0x50, // relative to content origin - location of foreground image (if it set no-repeat)

  SCROLLABLE_AREA = 0x60,   // scroll_area - scrollable area in content box

};

enum SCITER_SCROLL_FLAGS
{
  SCROLL_TO_TOP = 0x01,
  SCROLL_SMOOTH = 0x10,
};

/**Callback function used with #SciterVisitElement().*/
typedef BOOL SC_CALLBACK SciterElementCallback( HELEMENT he, LPVOID param );

enum SET_ELEMENT_HTML
{
  SIH_REPLACE_CONTENT     = 0,
  SIH_INSERT_AT_START     = 1,
  SIH_APPEND_AFTER_LAST   = 2,
  SOH_REPLACE             = 3,
  SOH_INSERT_BEFORE       = 4,
  SOH_INSERT_AFTER        = 5
};

/**Element callback function for all types of events. Similar to WndProc
 * \param tag \b LPVOID, tag assigned by SciterAttachElementProc function (like GWL_USERDATA)
 * \param he \b HELEMENT, this element handle (like HWINDOW)
 * \param evtg \b UINT, group identifier of the event, value is one of EVENT_GROUPS
 * \param prms \b LPVOID, pointer to group specific parameters structure.
 * \return TRUE if event was handled, FALSE otherwise.
 **/

typedef BOOL SC_CALLBACK ElementEventProc(LPVOID tag, HELEMENT he, UINT evtg, LPVOID prms );
typedef ElementEventProc* LPELEMENT_EVENT_PROC;

enum ELEMENT_STATE_BITS
{
  STATE_LINK             = 0x00000001,
  STATE_HOVER            = 0x00000002,
  STATE_ACTIVE           = 0x00000004,
  STATE_FOCUS            = 0x00000008,
  STATE_VISITED          = 0x00000010,
  STATE_CURRENT          = 0x00000020,  // current (hot) item
  STATE_CHECKED          = 0x00000040,  // element is checked (or selected)
  STATE_DISABLED         = 0x00000080,  // element is disabled
  STATE_READONLY         = 0x00000100,  // readonly input element
  STATE_EXPANDED         = 0x00000200,  // expanded state - nodes in tree view
  STATE_COLLAPSED        = 0x00000400,  // collapsed state - nodes in tree view - mutually exclusive with
  STATE_INCOMPLETE       = 0x00000800,  // one of fore/back images requested but not delivered
  STATE_ANIMATING        = 0x00001000,  // is animating currently
  STATE_FOCUSABLE        = 0x00002000,  // will accept focus
  STATE_ANCHOR           = 0x00004000,  // anchor in selection (used with current in selects)
  STATE_SYNTHETIC        = 0x00008000,  // this is a synthetic element - don't emit it's head/tail
  STATE_OWNS_POPUP       = 0x00010000,  // this is a synthetic element - don't emit it's head/tail
  STATE_TABFOCUS         = 0x00020000,  // focus gained by tab traversal
  STATE_EMPTY            = 0x00040000,  // empty - element is empty (text.size() == 0 && subs.size() == 0)
                                        //  if element has behavior attached then the behavior is responsible for the value of this flag.
  STATE_BUSY             = 0x00080000,  // busy; loading

  STATE_DRAG_OVER        = 0x00100000,  // drag over the block that can accept it (so is current drop target). Flag is set for the drop target block
  STATE_DROP_TARGET      = 0x00200000,  // active drop target.
  STATE_MOVING           = 0x00400000,  // dragging/moving - the flag is set for the moving block.
  STATE_COPYING          = 0x00800000,  // dragging/copying - the flag is set for the copying block.
  STATE_DRAG_SOURCE      = 0x01000000,  // element that is a drag source.
  STATE_DROP_MARKER      = 0x02000000,  // element is drop marker

  STATE_PRESSED          = 0x04000000,  // pressed - close to active but has wider life span - e.g. in MOUSE_UP it
                                        //   is still on; so behavior can check it in MOUSE_UP to discover CLICK condition.
  STATE_POPUP            = 0x08000000,  // this element is out of flow - popup

  STATE_IS_LTR           = 0x10000000,  // the element or one of its containers has dir=ltr declared
  STATE_IS_RTL           = 0x20000000,  // the element or one of its containers has dir=rtl declared

};

enum REQUEST_TYPE
{
  GET_ASYNC,  // async GET
  POST_ASYNC, // async POST
  GET_SYNC,   // synchronous GET
  POST_SYNC   // synchronous POST
};

/**Callback comparator function used with #SciterSortElements().
  Shall return -1,0,+1 values to indicate result of comparison of two elements
 **/
typedef INT SC_CALLBACK ELEMENT_COMPARATOR( HELEMENT he1, HELEMENT he2, LPVOID param );

enum CTL_TYPE
{
    CTL_NO,               ///< This dom element has no behavior at all.
    CTL_UNKNOWN = 1,      ///< This dom element has behavior but its type is unknown.
    CTL_EDIT,             ///< Single line edit box.
    CTL_NUMERIC,          ///< Numeric input with optional spin buttons.
    CTL_CLICKABLE,        ///< toolbar button, behavior:clickable.
    CTL_BUTTON,           ///< Command button.
    CTL_CHECKBOX,         ///< CheckBox (button).
    CTL_RADIO,            ///< OptionBox (button).
    CTL_SELECT_SINGLE,    ///< Single select, ListBox or TreeView.
    CTL_SELECT_MULTIPLE,  ///< Multiselectable select, ListBox or TreeView.
    CTL_DD_SELECT,        ///< Dropdown single select.
    CTL_TEXTAREA,         ///< Multiline TextBox.
    CTL_HTMLAREA,         ///< WYSIWYG HTML editor.
    CTL_PASSWORD,         ///< Password input element.
    CTL_PROGRESS,         ///< Progress element.
    CTL_SLIDER,           ///< Slider input element.
    CTL_DECIMAL,          ///< Decimal number input element.
    CTL_CURRENCY,         ///< Currency input element.
    CTL_SCROLLBAR,

    CTL_HYPERLINK,

    CTL_MENUBAR,
    CTL_MENU,
    CTL_MENUBUTTON,

    CTL_CALENDAR,
    CTL_DATE,
    CTL_TIME,

    CTL_FRAME,
    CTL_FRAMESET,

    CTL_GRAPHICS,
    CTL_SPRITE,

    CTL_LIST,
    CTL_RICHTEXT,
    CTL_TOOLTIP,

    CTL_HIDDEN,
    CTL_URL,            ///< URL input element.
    CTL_TOOLBAR,

    CTL_FORM,
    CTL_FILE,           ///< file input element.
    CTL_PATH,           ///< path input element.
    CTL_WINDOW,         ///< has HWND attached to it

    CTL_LABEL,
    CTL_IMAGE,            ///< image/object.

};

enum NODE_TYPE
{
  NT_ELEMENT,
  NT_TEXT,
  NT_COMMENT
};

enum NODE_INS_TARGET
{
  NIT_BEFORE,
  NIT_AFTER,
  NIT_APPEND,
  NIT_PREPEND,
};

#include "sciter-x-behavior.h"

#endif
