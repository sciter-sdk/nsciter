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
## #  Sciter basic types, platform isolation declarations
## #

when not defined(windows):
  include widestr

type
  Rect* = object
    left*: int32
    top*: int32
    right*: int32
    bottom*: int32

  Point* = object
    x*: int32
    y*: int32

  Size* = object
    cx*: int32
    cy*: int32

  LPCWSTR_RECEIVER* = proc (str: ptr WideCString; str_length: cuint; param: pointer) {.cdecl.}
  LPCSTR_RECEIVER* = proc (str: cstring; str_length: cuint; param: pointer) {.cdecl.}
  LPCBYTE_RECEIVER* = proc (str: ptr byte; num_bytes: cuint; param: pointer) {.cdecl.}

when defined(windows):
  import winlean
  const
    whdr = "<windows.h>"
    # d2hdr = "<D2d1.h>"
  type
    HWINDOW* = pointer
    WPARAM* = ByteAddress
    LPARAM* = ByteAddress
    LRESULT* = ByteAddress
    MSG* {.header:whdr, importc.} = object
    # ID2D1RenderTarget* {.header:d2hdr, importc.} = object
    # IDXGISwapChain* {.header:d2hdr, importc.} = object
    # IDXGISurface* {.header:d2hdr, importc.} = object
    # ID2D1Factory* {.header:d2hdr, importc.} = object
    # IDWriteFactory* {.header:d2hdr, importc.} = object

  when hostCPU == "amd64":
    const
      TARGET_64* = true
      SCITER_DLL_NAME* = "sciter64.dll"
  else:
    const
      TARGET_32* = true
      SCITER_DLL_NAME* = "sciter32.dll"

when defined(posix):
  const
    ghdr = "<gtk/gtk.h>"
  type
    HWINDOW* {.header:ghdr, importc:"GtkWindow*".} = pointer
    HINSTANCE* = pointer

  when hostCPU == "amd64":
    const
      TARGET_64* = true
      SCITER_DLL_NAME* = "libsciter-gtk-64.so"
  else:
    const
      TARGET_32* = true
      SCITER_DLL_NAME* = "libsciter-gtk-32.so"

when defined(osx):
  type
    HWINDOW* = pointer   # NSView*
    HINSTANCE* = pointer # NSApplication*

  when hostCPU == "amd64":
    const
      TARGET_64* = true
      SCITER_DLL_NAME* = "sciter-osx-64.dylib"
  else:
    const
      TARGET_32* = true
      SCITER_DLL_NAME* = "sciter-osx-32.dylib"
