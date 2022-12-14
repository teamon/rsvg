CFLAGS ?= -g -O3
CFLAGS += -Wall -Wno-format-truncation -fPIC
CFLAGS += -I$(ERTS_INCLUDE_DIR)

LDFLAGS += $(shell pkg-config --cflags --libs librsvg-2.0)

PRIV_DIR = $(MIX_APP_PATH)/priv
OBJECT = $(PRIV_DIR)/rsvg.so

ifeq ($(shell uname),Darwin)
	LDFLAGS += -dynamiclib -undefined dynamic_lookup
endif

all: $(PRIV_DIR) $(OBJECT)

$(PRIV_DIR):
	mkdir -p "$(PRIV_DIR)"

$(OBJECT): c_src/rsvg.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) $^ -o $(OBJECT)

clean:
	rm -f $(OBJECT)

.PHONY: all clean
