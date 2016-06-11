converter toUnt32*(x: SCITER_CREATE_WINDOW_FLAGS): uint32 =
  result = uint32(x)
  
converter toWideCString*(s: string):WideCString =
  return newWideCString(s)