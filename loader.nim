import dynlib

proc SAPI*():ptr ISciterAPI {.cdecl.} =
  var libhandle = loadLib("./"&SCITER_DLL_NAME)
  var procPtr = symAddr(libhandle, "SciterAPI")
  let p = cast[SciterAPI_ptr](procPtr)
  return p()
  
proc gapi*():LPSciterGraphicsAPI {.cdecl.} =
  return SAPI().GetSciterGraphicsAPI()
  
proc rapi*():LPSciterRequestAPI {.cdecl.} =
  return SAPI().GetSciterRequestAPI()