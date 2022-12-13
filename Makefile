ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -g -O3 -ansi -Werror -I$(ERLANG_PATH) -fPIC

ifeq ($(shell uname), Darwin)
	LDFLAGS += -dynamiclib -undefined dynamic_lookup
endif

LDFLAGS += $(shell pkg-config --cflags --libs librsvg-2.0)

all: $(MIX_APP_PATH)/priv/rsvg.so

$(MIX_APP_PATH)/priv/rsvg.so: c_src/rsvg.c
	mkdir -p $(MIX_APP_PATH)/priv
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ c_src/rsvg.c

clean:
	rm -r $(MIX_APP_PATH)/priv/rsvg.so*

.PHONY: clean
