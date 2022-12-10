ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -g -O3 -ansi -Werror -I$(ERLANG_PATH)

# if unix
CFLAGS += -fPIC
# if macos
CFLAGS += -dynamiclib -undefined dynamic_lookup

all: priv/rsvg.so

priv/rsvg.so: c_src/rsvg.c
	mkdir -p ./priv
	$(CC) $(CFLAGS) $(LDFLAGS) $$(pkg-config --cflags --libs librsvg-2.0) -shared -o $@ c_src/rsvg.c

clean:
	rm -r priv/rsvg.so*

.PHONY: clean
