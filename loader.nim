import dynlib,os

var api:ptr ISciterAPI = nil

proc SAPI*():ptr ISciterAPI {.inline, cdecl.} =
  if api != nil:
    return api
  var libhandle = loadLib(SCITER_DLL_NAME)
  if libhandle == nil:
    libhandle = loadLib(getCurrentDir()&"/"&SCITER_DLL_NAME)
  if libhandle == nil:
    quit "sciter runtime library not found: "&SCITER_DLL_NAME
    return nil
  var procPtr = symAddr(libhandle, "SciterAPI")
  let p = cast[SciterAPI_ptr](procPtr)
  api = p()
  return api

proc gapi*():LPSciterGraphicsAPI {.inline, cdecl.} =
  return SAPI().GetSciterGraphicsAPI()

proc rapi*():LPSciterRequestAPI {.inline, cdecl.} =
  return SAPI().GetSciterRequestAPI()
