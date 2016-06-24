
include xapi, event, utils

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