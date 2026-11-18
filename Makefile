# --- build-time configuration, override with: make VAR=value ---
PREFIX          ?= /usr
BINDIR          ?= $(PREFIX)/bin
LIBEXECDIR      ?= $(PREFIX)/libexec/genlimineconf
KERNELHOOKDIR   ?= /etc/kernel.d
CONFDIR_PATH    ?= /etc/genlimineconf
CONFDIR_NAME    ?= limine.conf.d
ENTRIESDIR_PATH ?= /var/lib/genlimineconf
ENTRIESDIR_NAME ?= entries
KERNEL_NAME     ?= linux
KERNEL_PATH     ?=

DESTDIR         ?=

-include config.mk

SUBST = sed -e 's|@LIBEXECDIR_PATH@|$(LIBEXECDIR)|g' \
            -e 's|@EXECDIR_PATH@|$(BINDIR)|g' \
            -e 's|@KERNEL_NAME@|$(KERNEL_NAME)|g' \
            -e 's|@KERNEL_PATH@|$(KERNEL_PATH)|g' \
            -e 's|@CONFDIR_PATH@|$(CONFDIR_PATH)|g' \
            -e 's|@CONFDIR_NAME@|$(CONFDIR_NAME)|g' \
            -e 's|@ENTRIESDIR_PATH@|$(ENTRIESDIR_PATH)|g' \
            -e 's|@ENTRIESDIR_NAME@|$(ENTRIESDIR_NAME)|g'

LIB_SRC := $(wildcard src/lib/*.sh)
LIB_OUT := $(patsubst src/lib/%,dist$(LIBEXECDIR)/lib/%,$(LIB_SRC))

CMD_SRC := $(wildcard src/cmd/*.sh)
CMD_OUT := $(patsubst src/cmd/%,dist$(LIBEXECDIR)/%,$(CMD_SRC))

MAIN_OUT := dist$(BINDIR)/genlimineconf

HOOK_INSTALL_OUT := dist$(KERNELHOOKDIR)/post-install/100-genlimineconf
HOOK_REMOVE_OUT  := dist$(KERNELHOOKDIR)/post-remove/100-genlimineconf

STATIC_OUT := dist$(CONFDIR_PATH)/$(CONFDIR_NAME)/options.conf

ENTRIESDIR_OUT := dist$(ENTRIESDIR_PATH)/$(ENTRIESDIR_NAME)

.PHONY: all clean install

all: $(MAIN_OUT) $(LIB_OUT) $(CMD_OUT) $(HOOK_INSTALL_OUT) $(HOOK_REMOVE_OUT) $(STATIC_OUT) $(ENTRIESDIR_OUT)

$(MAIN_OUT): src/main.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

dist$(LIBEXECDIR)/lib/%.sh: src/lib/%.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 644 $@

dist$(LIBEXECDIR)/%.sh: src/cmd/%.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

$(ENTRIESDIR_OUT):
	install -d $@

$(HOOK_INSTALL_OUT): src/hooks/xbps/kernel/post_install.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

$(HOOK_REMOVE_OUT): src/hooks/xbps/kernel/post_remove.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

$(STATIC_OUT): static/default_limine_user_options.conf
	@mkdir -p $(dir $@)
	cp $< $@
	chmod 644 $@

clean:
	rm -rf dist

install: all
	cp -r dist/. $(DESTDIR)/
