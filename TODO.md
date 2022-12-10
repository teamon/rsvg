## Test on Alpine

```
docker build -f test/Dockerfile.alpine .

#12 2.139 Package librsvg-2.0 was not found in the pkg-config search path.
#12 2.139 Perhaps you should add the directory containing `librsvg-2.0.pc'
#12 2.139 to the PKG_CONFIG_PATH environment variable
#12 2.139 Package 'librsvg-2.0', required by 'virtual:world', not found
#12 2.139 mkdir -p ./priv
#12 2.139 cc -g -O3 -ansi -Werror -I/usr/local/lib/erlang/erts-13.1.2/include -fPIC -shared  -o priv/rsvg.so c_src/rsvg.c
#12 2.139 c_src/rsvg.c:2:10: fatal error: librsvg/rsvg.h: No such file or directory
#12 2.139     2 | #include <librsvg/rsvg.h>
#12 2.139 compilation terminated.
#12 2.139 make: *** [Makefile:14: priv/rsvg.so] Error 1
```

## Test on Ubuntu

```
docker build -f test/Dockerfile.ubuntu .

#11 2.221 ==> rsvg
#11 2.222 Compiling 1 file (.ex)
#11 2.239
#11 2.239 14:19:29.382 [warning] The on_load function for module Elixir.RSVG returned:
#11 2.239 {:error,
#11 2.239  {:load_failed,
#11 2.239   'Failed to load NIF library: \'/app/_build/test/lib/rsvg/priv/rsvg.so: undefined symbol: g_object_unref\''}}
```

## Test on macOS - DONE
