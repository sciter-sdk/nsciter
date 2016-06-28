
include xapi, event, valueprocs

when defined(posix):
    # {.passC: "-std=c++11".}
    {.passC: gorge("pkg-config gtk+-3.0 --cflags").}
    {.passL: gorge("pkg-config gtk+-3.0 --libs").}
    const
        gtkhdr = "<gtk/gtk.h>"
        gtklib = "libgtk-3.so.0"
    type
        GtkWidget {.final, header:gtkhdr, importc.} = object
        GtkWindow {.final, header:gtkhdr, importc.} = object
    {.emit:
        """
        #include <gtk/gtk.h>
        GtkWindow* gwindow(GtkWidget* hwnd) {
            printf("hwnd:%d\n", hwnd);
            return GTK_WINDOW(gtk_widget_get_toplevel(hwnd));
        }
        """
    .}
    proc gwindow(h:ptr GtkWidget):ptr GtkWindow {.importc:"gwindow".}
    proc gtk_init(a,b:int) {.dynlib:gtklib, importc:"gtk_init".}
    proc gtk_main() {.dynlib:gtklib, importc:"gtk_main".}
    proc gtk_window_present(w:ptr GtkWindow) {.dynlib:gtklib, importc:"gtk_window_present".}
    proc gtk_window_set_title(w:ptr GtkWindow, title:cstring) {.dynlib:gtklib, importc:"gtk_window_set_title".}
    proc gtk_widget_get_toplevel(w:ptr GtkWidget):ptr GtkWidget {.dynlib:gtklib, importc:"gtk_widget_get_toplevel".}
    gtk_init(0,0)
    proc setTitle*(h:HWINDOW, title:string) = 
        # setTitle set the window title for the GTK window
        var w = gwindow(cast[ptr GtkWidget](h))
        gtk_window_set_title(w, cstring(title))
    proc run*(hwnd: HWINDOW) =
        # run start the underly GTK window for sciter
        var w = gtk_widget_get_toplevel(cast[ptr GtkWidget](hwnd))
        gtk_window_present(gwindow(w))
        gtk_main()

when defined(windows):
    proc SetWindowText(wnd: HWINDOW, lpString: WideCString): bool {.stdcall,
                                             dynlib: "user32", importc: "SetWindowTextW".}
    proc GetMessage(lpMsg: ptr MSG, wnd: HWINDOW, wMsgFilterMin: uint32,
                    wMsgFilterMax: uint32): bool {.stdcall, dynlib: "user32", importc: "GetMessageW".}
    proc TranslateMessage(lpMsg: ptr MSG): bool {.stdcall, dynlib: "user32", importc: "TranslateMessage".}
    proc DispatchMessage(lpMsg: ptr MSG): LONG{.stdcall, dynlib: "user32", importc: "DispatchMessageW".}
    proc UpdateWindow(wnd: HWINDOW): bool{.stdcall, dynlib: "user32", importc: "UpdateWindow".}
    proc ShowWindow(wnd: HWINDOW, nCmdShow: int32): WINBOOL{.stdcall, dynlib: "user32", importc: "ShowWindow".}
    proc setTitle*(h:HWINDOW, title:string) = 
        discard SetWindowText(h, newWideCString(title))

    proc run*(hwnd: HWINDOW) =
        var m:MSG
        discard hwnd.ShowWindow(5)
        discard hwnd.UpdateWindow()
        while GetMessage(m.addr, nil, 0, 0):
            discard TranslateMessage(m.addr)
            discard DispatchMessage(m.addr)
