NSRC = sciter.nim xapi.nim xdef.nim xbehavior.nim loader.nim \
	   xdom.nim xgraphics.nim xrequest.nim xvalue.nim xtiscript.nim

sciter:${NSRC}
	nim c sciter

xapi.nim:include/sciter-x-api.h
	c2nim -o:$@ $^
	
xdef.nim:include/sciter-x-def.h
	c2nim -o:$@ $^
	
xbehavior.nim:include/sciter-x-behavior.h
	c2nim -o:$@ $^
	
xdom.nim:include/sciter-x-dom.h
	c2nim -o:$@ $^
	
xgraphics.nim:include/sciter-x-graphics.h
	c2nim -o:$@ $^
	
xrequest.nim:include/sciter-x-request.h
	c2nim -o:$@ $^

xvalue.nim:include/value.h
	c2nim -o:$@ $^

xtiscript.nim:include/tiscript.h
	c2nim -o:$@ $^

clean:
	rm -rf sciter nimcache xapi.nim xdef.nim xdom.nim xgraphics.nim xrequest.nim xtiscript.nim xvalue.nim xbehavior.nim