NSRC =  test.nim sciter.nim xapi.nim xdef.nim xbehavior.nim loader.nim \
				xdom.nim xgraphics.nim xrequest.nim xvalue.nim xtiscript.nim \
				event.nim valueprocs.nim

test:${NSRC}
	nim c test

xapi.nim:include/sciter-x-api.h
	c2nim -o:$@ $^
	# callbacks
	sed -i 's/ptr SciterElementCallback/SciterElementCallback/g' $@
	sed -i 's/ptr SciterWindowDelegate/SciterWindowDelegate/g' $@
	sed -i 's/ptr KeyValueCallback/KeyValueCallback/g' $@
	sed -i 's/ptr NATIVE_FUNCTOR_INVOKE/NATIVE_FUNCTOR_INVOKE/g' $@
	sed -i 's/ptr NATIVE_FUNCTOR_RELEASE/NATIVE_FUNCTOR_RELEASE/g' $@
	# receivers
	sed -i 's/ptr LPCSTR_RECEIVER/LPCSTR_RECEIVER/g' $@
	sed -i 's/ptr LPCWSTR_RECEIVER/LPCWSTR_RECEIVER/g' $@
	sed -i 's/ptr LPCBYTE_RECEIVER/LPCBYTE_RECEIVER/g' $@

xdef.nim:include/sciter-x-def.h
	c2nim -o:$@ $^

xbehavior.nim:include/sciter-x-behavior.h
	c2nim -o:$@ $^
	sed -i 's/EVENT_GROUPS\* \= enum/EVENT_GROUPS\* {\.size: sizeof(cint)\.} \= enum/g' $@

xdom.nim:include/sciter-x-dom.h
	c2nim -o:$@ $^
	sed -i '/HELEMENT\* \=/c\  HELEMENT* = distinct pointer' $@

xgraphics.nim:include/sciter-x-graphics.h
	c2nim -o:$@ $^

xrequest.nim:include/sciter-x-request.h
	c2nim -o:$@ $^

xvalue.nim:include/value.h
	c2nim -o:$@ $^

xtiscript.nim:include/tiscript.h
	c2nim -o:$@ $^

clean:
	rm -rf 	sciter nimcache xapi.nim xdef.nim xdom.nim xgraphics.nim xrequest.nim xtiscript.nim xvalue.nim xbehavior.nim \
					test
