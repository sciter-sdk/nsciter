import dynlib,os

var api:ptr ISciterAPI = nil

proc SAPI*():ptr ISciterAPI {.cdecl.} =
  if api != nil:
    return api
  var libhandle = loadLib(SCITER_DLL_NAME)
  if libhandle == nil:
    libhandle = loadLib(getCurrentDir()&"/"&SCITER_DLL_NAME)
  if libhandle == nil:
    return nil
  var procPtr = symAddr(libhandle, "SciterAPI")
  let p = cast[SciterAPI_ptr](procPtr)
  return p()
  
proc gapi*():LPSciterGraphicsAPI {.cdecl.} =
  return SAPI().GetSciterGraphicsAPI()
  
proc rapi*():LPSciterRequestAPI {.cdecl.} =
  return SAPI().GetSciterRequestAPI()