
include xapi

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

import os,strutils
        
when isMainModule:
    # echo repr SAPI()
    echo SciterClassName()
    var s = SAPI()
    echo "spi:", repr s
    echo "s.version:", s.version
    echo "s.SciterClassName:", s.SciterClassName()
    echo "s.SciterVersion:", toHex(int(s.SciterVersion(false)), 5)
    echo "s.SciterVersion:", toHex(int(s.SciterVersion(true)), 5)
    # echo SciterVersion(false)
    echo "SciterCreateWindow:", repr SciterCreateWindow
    echo "s.SciterCreateWindow:", repr s.SciterCreateWindow
    var r = cast[ptr Rect](alloc0(sizeof(Rect)))
    r.top = 0
    r.left = 0
    r.bottom = 300
    r.right = 300
    var wnd = SciterCreateWindow(cuint(SW_CONTROLS or SW_MAIN or SW_TITLEBAR), r, nil, nil, nil)
    # var wnd = SciterCreateWindow(0, nil, nil, nil, nil)
    if wnd == nil:
        quit("wnd is nil")
    var html = "hello"
    echo "wnd:", repr wnd
    wnd.setTitle("test")
    discard wnd.SciterLoadHtml(html, 5, newWideCString("."))
    wnd.run