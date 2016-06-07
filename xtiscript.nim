import xtypes
type
  tiscript_VM* = object
  

## # TIScript virtual machine


## # tiscript_value

type
  tiscript_value* = culonglong
  HVM* = ptr tiscript_VM

## # pinned tiscript_value, val here will survive GC.

type
  tiscript_pvalue* = object
    val*: tiscript_value
    vm*: ptr tiscript_VM
    d1*: pointer
    d2*: pointer

  tiscript_stream_input* = proc (tag: ptr tiscript_stream; pv: ptr cint): bool
  tiscript_stream_output* = proc (tag: ptr tiscript_stream; v: cint): bool
  tiscript_stream_name* = proc (tag: ptr tiscript_stream): ptr WideCString
  tiscript_stream_close* = proc (tag: ptr tiscript_stream)
  tiscript_stream_vtbl* = object
    input*: ptr tiscript_stream_input
    output*: ptr tiscript_stream_output
    get_name*: ptr tiscript_stream_name
    close*: ptr tiscript_stream_close

  tiscript_stream* = object
    vtbl*: ptr tiscript_stream_vtbl


## # native method implementation

type
  tiscript_method* = proc (c: ptr tiscript_VM): tiscript_value
  tiscript_tagged_method* = proc (c: ptr tiscript_VM; self: tiscript_value; tag: pointer): tiscript_value

## # [] accessors implementation

type
  tiscript_get_item* = proc (c: ptr tiscript_VM; obj: tiscript_value;
                          key: tiscript_value): tiscript_value
  tiscript_set_item* = proc (c: ptr tiscript_VM; obj: tiscript_value;
                          key: tiscript_value; tiscript_value: tiscript_value)

## # getter/setter implementation

type
  tiscript_get_prop* = proc (c: ptr tiscript_VM; obj: tiscript_value): tiscript_value
  tiscript_set_prop* = proc (c: ptr tiscript_VM; obj: tiscript_value;
                          tiscript_value: tiscript_value)

## # iterator function used in for(var el in collection)

type
  tiscript_iterator* = proc (c: ptr tiscript_VM; index: ptr tiscript_value;
                          obj: tiscript_value): tiscript_value

## # callbacks for enums below

type
  tiscript_object_enum* = proc (c: ptr tiscript_VM; key: tiscript_value;
                             tiscript_value: tiscript_value; tag: pointer): bool

## # true - continue enumeartion
## # destructor of native objects

type
  tiscript_finalizer* = proc (c: ptr tiscript_VM; obj: tiscript_value)

## # GC notifier for native objects

type
  tiscript_on_gc_copy* = proc (instance_data: pointer; new_self: tiscript_value)

## # callback used for

type
  tiscript_callback* = proc (c: ptr tiscript_VM; prm: pointer)
  tiscript_method_def* = object
    dispatch*: pointer         ## # a.k.a. VTBL
    name*: cstring
    handler*: ptr tiscript_method ## # or tiscript_tagged_method if tag is not 0
    tag*: pointer
    payload*: tiscript_value   ## # must be zero
  
  tiscript_prop_def* = object
    dispatch*: pointer         ## # a.k.a. VTBL
    name*: cstring
    getter*: ptr tiscript_get_prop
    setter*: ptr tiscript_set_prop
    tag*: pointer


const
  TISCRIPT_CONST_INT* = 0
  TISCRIPT_CONST_FLOAT* = 1
  TISCRIPT_CONST_STRING* = 2

type
  INNER_C_UNION_8636835370559314551* = object {.union.}
    i*: cint
    f*: cdouble
    str*: ptr WideCString

  tiscript_const_def* = object
    name*: cstring
    val*: INNER_C_UNION_8636835370559314551
    `type`*: cuint

  tiscript_class_def* = object
    name*: cstring             ## # having this name
    methods*: ptr tiscript_method_def ## # with these methods
    props*: ptr tiscript_prop_def ## # with these properties
    consts*: ptr tiscript_const_def ## # with these constants (if any)
    get_item*: ptr tiscript_get_item ## # var v = obj[idx]
    set_item*: ptr tiscript_set_item ## # obj[idx] = v
    finalizer*: ptr tiscript_finalizer ## # destructor of native objects
    `iterator`*: ptr tiscript_iterator ## # for(var el in collecton) handler
    on_gc_copy*: ptr tiscript_on_gc_copy ## # called by GC to notify that 'self' is moved to new location
    prototype*: tiscript_value ## # superclass, prototype for the class (or 0)
  
  tiscript_native_interface* = object
    create_vm*: proc (features: cuint; ## # create new tiscript_VM [and make it current for the thread].
    ## # destroy tiscript_VM
    ## #= 0xffffffff
                    heap_size: cuint; ## #= 1*1024*1024
                    stack_size: cuint): ptr tiscript_VM ## #= 64*1024
    destroy_vm*: proc (pvm: ptr tiscript_VM) ## # invoke GC
    invoke_gc*: proc (pvm: ptr tiscript_VM) ## # set stdin, stdout and stderr for this tiscript_VM
    set_std_streams*: proc (pvm: ptr tiscript_VM; input: ptr tiscript_stream;
                          output: ptr tiscript_stream; error: ptr tiscript_stream) ## # get 
                                                                             ## tiscript_VM 
                                                                             ## attached to the 
                                                                             ## current 
                                                                             ## thread
    get_current_vm*: proc (): ptr tiscript_VM ## # get global namespace (Object)
    get_global_ns*: proc (a2: ptr tiscript_VM): tiscript_value ## # get current namespace (Object)
    get_current_ns*: proc (a2: ptr tiscript_VM): tiscript_value
    is_int*: proc (v: tiscript_value): bool
    is_float*: proc (v: tiscript_value): bool
    is_symbol*: proc (v: tiscript_value): bool
    is_string*: proc (v: tiscript_value): bool
    is_array*: proc (v: tiscript_value): bool
    is_object*: proc (v: tiscript_value): bool
    is_native_object*: proc (v: tiscript_value): bool
    is_function*: proc (v: tiscript_value): bool
    is_native_function*: proc (v: tiscript_value): bool
    is_instance_of*: proc (v: tiscript_value; cls: tiscript_value): bool
    is_undefined*: proc (v: tiscript_value): bool
    is_nothing*: proc (v: tiscript_value): bool
    is_null*: proc (v: tiscript_value): bool
    is_true*: proc (v: tiscript_value): bool
    is_false*: proc (v: tiscript_value): bool
    is_class*: proc (a2: ptr tiscript_VM; v: tiscript_value): bool
    is_error*: proc (v: tiscript_value): bool
    is_bytes*: proc (v: tiscript_value): bool
    is_datetime*: proc (a2: ptr tiscript_VM; v: tiscript_value): bool
    get_int_value*: proc (v: tiscript_value; pi: ptr cint): bool
    get_float_value*: proc (v: tiscript_value; pd: ptr cdouble): bool
    get_bool_value*: proc (v: tiscript_value; pb: ptr bool): bool
    get_symbol_value*: proc (v: tiscript_value; psz: ptr ptr WideCString): bool
    get_string_value*: proc (v: tiscript_value; pdata: ptr ptr WideCString;
                           plength: ptr cuint): bool
    get_bytes*: proc (v: tiscript_value; pb: ptr ptr cuchar; pblen: ptr cuint): bool
    get_datetime*: proc (a2: ptr tiscript_VM; v: tiscript_value; dt: ptr culonglong): bool ## 
                                                                                ## # 
                                                                                ## dt 
                                                                                ## - 
                                                                                ## 64-bit 
                                                                                ## value 
                                                                                ## representing 
                                                                                ## the 
                                                                                ## number 
                                                                                ## of 
                                                                                ## 100-nanosecond 
                                                                                ## intervals 
                                                                                ## since 
                                                                                ## January 
                                                                                ## 1, 
                                                                                ## 1601 
                                                                                ## (UTC)
                                                                                ## 
                                                                                ## # 
                                                                                ## a.k.a. 
                                                                                ## FILETIME 
                                                                                ## in 
                                                                                ## Windows
    nothing_value*: proc (): tiscript_value ## # special value that designates "does not exist" result.
    undefined_value*: proc (): tiscript_value
    null_value*: proc (): tiscript_value
    bool_value*: proc (v: bool): tiscript_value
    int_value*: proc (v: cint): tiscript_value
    float_value*: proc (v: cdouble): tiscript_value
    string_value*: proc (a2: ptr tiscript_VM; text: ptr WideCString; text_length: cuint): tiscript_value
    symbol_value*: proc (zstr: cstring): tiscript_value
    bytes_value*: proc (a2: ptr tiscript_VM; data: ptr byte; data_length: cuint): tiscript_value
    datetime_value*: proc (a2: ptr tiscript_VM; dt: culonglong): tiscript_value
    to_string*: proc (a2: ptr tiscript_VM; v: tiscript_value): tiscript_value ## # define native class
    define_class*: proc (vm: ptr tiscript_VM; cls: ptr tiscript_class_def; zns: tiscript_value): tiscript_value ## 
                                                                                                     ## # 
                                                                                                     ## object
    ## # in this tiscript_VM
    ## #
    ## # in this namespace object (or 0 if global)
    create_object*: proc (a2: ptr tiscript_VM; of_class: tiscript_value): tiscript_value ## 
                                                                                 ## # 
                                                                                 ## of_class 
                                                                                 ## == 
                                                                                 ## 0 
                                                                                 ## - 
                                                                                 ## "Object"
    set_prop*: proc (a2: ptr tiscript_VM; obj: tiscript_value; key: tiscript_value;
                   tiscript_value: tiscript_value): bool
    get_prop*: proc (a2: ptr tiscript_VM; obj: tiscript_value; key: tiscript_value): tiscript_value
    for_each_prop*: proc (a2: ptr tiscript_VM; obj: tiscript_value;
                        cb: ptr tiscript_object_enum; tag: pointer): bool
    get_instance_data*: proc (obj: tiscript_value): pointer
    set_instance_data*: proc (obj: tiscript_value; data: pointer) ## # array
    create_array*: proc (a2: ptr tiscript_VM; of_size: cuint): tiscript_value
    set_elem*: proc (a2: ptr tiscript_VM; obj: tiscript_value; idx: cuint;
                   tiscript_value: tiscript_value): bool
    get_elem*: proc (a2: ptr tiscript_VM; obj: tiscript_value; idx: cuint): tiscript_value
    set_array_size*: proc (a2: ptr tiscript_VM; obj: tiscript_value; of_size: cuint): tiscript_value
    get_array_size*: proc (a2: ptr tiscript_VM; obj: tiscript_value): cuint ## # eval
    eval*: proc (a2: ptr tiscript_VM; ns: tiscript_value; input: ptr tiscript_stream;
               template_mode: bool; pretval: ptr tiscript_value): bool
    eval_string*: proc (a2: ptr tiscript_VM; ns: tiscript_value;
                      script: ptr WideCString; script_length: cuint;
                      pretval: ptr tiscript_value): bool ## # call function (method)
    call*: proc (a2: ptr tiscript_VM; obj: tiscript_value; function: tiscript_value;
               argv: ptr tiscript_value; argn: cuint; pretval: ptr tiscript_value): bool ## 
                                                                                ## # 
                                                                                ## compiled 
                                                                                ## bytecodes
    compile*: proc (pvm: ptr tiscript_VM; input: ptr tiscript_stream;
                  output_bytecodes: ptr tiscript_stream; template_mode: bool): bool
    loadbc*: proc (pvm: ptr tiscript_VM; input_bytecodes: ptr tiscript_stream): bool ## # 
                                                                            ## throw 
                                                                            ## error
    throw_error*: proc (a2: ptr tiscript_VM; error: ptr WideCString) ## # arguments access
    get_arg_count*: proc (pvm: ptr tiscript_VM): cuint
    get_arg_n*: proc (pvm: ptr tiscript_VM; n: cuint): tiscript_value ## # path here is global "path" of the object, something like
                                                              ## # "one"
                                                              ## # "one.two", etc.
    get_value_by_path*: proc (pvm: ptr tiscript_VM; v: ptr tiscript_value; path: cstring): bool ## 
                                                                                     ## # 
                                                                                     ## pins
    pin*: proc (a2: ptr tiscript_VM; pp: ptr tiscript_pvalue)
    unpin*: proc (pp: ptr tiscript_pvalue) ## # create native_function_value and native_property_value,
                                      ## # use this if you want to add native functions/properties in runtime to exisiting classes or namespaces (including global ns)
    native_function_value*: proc (pvm: ptr tiscript_VM;
                                p_method_def: ptr tiscript_method_def): tiscript_value
    native_property_value*: proc (pvm: ptr tiscript_VM;
                                p_prop_def: ptr tiscript_prop_def): tiscript_value ## # 
                                                                               ## Schedule 
                                                                               ## execution 
                                                                               ## of 
                                                                               ## the 
                                                                               ## pfunc(prm) 
                                                                               ## in 
                                                                               ## the 
                                                                               ## thread 
                                                                               ## owning 
                                                                               ## this 
                                                                               ## VM.
                                                                               ## # 
                                                                               ## Used 
                                                                               ## when 
                                                                               ## you 
                                                                               ## need 
                                                                               ## to 
                                                                               ## call 
                                                                               ## scripting 
                                                                               ## methods 
                                                                               ## from 
                                                                               ## threads 
                                                                               ## other 
                                                                               ## than 
                                                                               ## main 
                                                                               ## (GUI) 
                                                                               ## thread
                                                                               ## # 
                                                                               ## It 
                                                                               ## is 
                                                                               ## safe 
                                                                               ## to 
                                                                               ## call 
                                                                               ## tiscript 
                                                                               ## functions 
                                                                               ## inside 
                                                                               ## the 
                                                                               ## pfunc.
                                                                               ## # 
                                                                               ## returns 
                                                                               ## 'true' 
                                                                               ## if 
                                                                               ## scheduling 
                                                                               ## of 
                                                                               ## the 
                                                                               ## call 
                                                                               ## was 
                                                                               ## accepted, 
                                                                               ## 'false' 
                                                                               ## when 
                                                                               ## failure 
                                                                               ## (VM 
                                                                               ## has 
                                                                               ## no 
                                                                               ## dispatcher 
                                                                               ## attached).
    post*: proc (pvm: ptr tiscript_VM; pfunc: ptr tiscript_callback; prm: pointer): bool ## # 
                                                                              ## Introduce 
                                                                              ## alien VM to 
                                                                              ## the 
                                                                              ## host 
                                                                              ## VM:
                                                                              ## # 
                                                                              ## Calls 
                                                                              ## method 
                                                                              ## found on 
                                                                              ## "host_method_path" 
                                                                              ## (if 
                                                                              ## there is 
                                                                              ## any) on 
                                                                              ## the 
                                                                              ## pvm_host
                                                                              ## # 
                                                                              ## notifying 
                                                                              ## the 
                                                                              ## host 
                                                                              ## about 
                                                                              ## other VM 
                                                                              ## (alien) 
                                                                              ## creation. 
                                                                              ## Return 
                                                                              ## value of 
                                                                              ## script 
                                                                              ## function 
                                                                              ## "host_method_path" 
                                                                              ## running in 
                                                                              ## pvm_host is 
                                                                              ## passed
                                                                              ## # as a 
                                                                              ## parametr of a 
                                                                              ## call to 
                                                                              ## function at 
                                                                              ## "alien_method_path".
                                                                              ## # 
                                                                              ## One of 
                                                                              ## possible 
                                                                              ## uses of 
                                                                              ## this 
                                                                              ## function:
                                                                              ## # 
                                                                              ## Function at 
                                                                              ## "host_method_path" 
                                                                              ## creates 
                                                                              ## async 
                                                                              ## streams 
                                                                              ## that 
                                                                              ## will 
                                                                              ## serve a 
                                                                              ## role of 
                                                                              ## stdin, 
                                                                              ## stdout 
                                                                              ## and 
                                                                              ## stderr 
                                                                              ## for 
                                                                              ## the 
                                                                              ## alien 
                                                                              ## vm.
                                                                              ## # 
                                                                              ## This 
                                                                              ## way 
                                                                              ## two 
                                                                              ## VMs 
                                                                              ## can 
                                                                              ## communicate 
                                                                              ## with 
                                                                              ## each 
                                                                              ## other.
                                                                              ## 
                                                                              ## #unsigned      
                                                                              ## (TISAPI 
                                                                              ## *introduce_vm)(tiscript_VM* 
                                                                              ## pvm_host, 
                                                                              ## const 
                                                                              ## char* 
                                                                              ## host_method_path,  
                                                                              ## tiscript_VM* 
                                                                              ## pvm_alien, 
                                                                              ## const 
                                                                              ## char* 
                                                                              ## alien_method_path);
    set_remote_std_streams*: proc (pvm: ptr tiscript_VM; input: ptr tiscript_pvalue;
                                 output: ptr tiscript_pvalue;
                                 error: ptr tiscript_pvalue): bool ## # support of multi-return values from native fucntions, n here is a number 1..64
    set_nth_retval*: proc (pvm: ptr tiscript_VM; n: cint; ns: tiscript_value): bool ## # 
                                                                          ## returns number of props in 
                                                                          ## object, 
                                                                          ## elements in array, or bytes in byte array.
    get_length*: proc (pvm: ptr tiscript_VM; obj: tiscript_value): cint ## # for( var val in coll ) {...}
    get_next*: proc (pvm: ptr tiscript_VM; obj: ptr tiscript_value;
                   pos: ptr tiscript_value; val: ptr tiscript_value): bool ## # for( var (key,val) in coll ) {...}
    get_next_key_value*: proc (pvm: ptr tiscript_VM; obj: ptr tiscript_value;
                             pos: ptr tiscript_value; key: ptr tiscript_value;
                             val: ptr tiscript_value): bool ## # associate extra data pointer with the VM
    set_extra_data*: proc (pvm: ptr tiscript_VM; data: pointer): bool
    get_extra_data*: proc (pvm: ptr tiscript_VM): pointer


## ##ifdef TISCRIPT_EXT_MODULE
## #  extern tiscript_native_interface* TIScriptAPI;
## ##elif defined(SCITER_EXPORTS)
## #  EXTERN_C __declspec(dllexport) tiscript_native_interface* EXTAPI TIScriptAPI();
## ##else
## #  EXTERN_C __declspec(dllimport) tiscript_native_interface* EXTAPI TIScriptAPI();
## ##endif
## # signature of TIScriptLibraryInit function - entry point of TIScript Extnension Library

type
  TIScriptLibraryInitFunc* = proc (vm: ptr tiscript_VM;
                                piface: ptr tiscript_native_interface)
