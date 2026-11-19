# --- build-time configuration, override with: make VAR=value ---
PREFIX          ?= /usr
BINDIR          ?= $(PREFIX)/bin
CMDDIR          ?= $(PREFIX)/libexec/genlimineconf
LIBDIR          ?= $(CMDDIR)/lib
KERNELHOOKDIR   ?= /etc/kernel.d
CONFDIR         ?= /etc/genlimineconf/limine.conf.d
ENTRIESDIR      ?= /tmp/genlimineconf-XXXXXX
KERNEL_NAME     ?= linux
KERNEL_PATH     ?=

DESTDIR         ?=

-include config.mk

SUBST = sed -e 's|@LIBDIR_PATH@|$(LIBDIR)|g' \
            -e 's|@CMDDIR_PATH@|$(CMDDIR)|g' \
            -e 's|@BINDIR@|$(BINDIR)|g' \
            -e 's|@KERNEL_NAME@|$(KERNEL_NAME)|g' \
            -e 's|@KERNEL_PATH@|$(KERNEL_PATH)|g' \
            -e 's|@CONFDIR@|$(CONFDIR)|g' \
            -e 's|@ENTRIESDIR@|$(ENTRIESDIR)|g'

LIB_SRC := $(wildcard src/lib/*.sh)
LIB_OUT := $(patsubst src/lib/%,dist$(LIBDIR)/%,$(LIB_SRC))

CMD_SRC := $(wildcard src/cmd/*.sh)
CMD_OUT := $(patsubst src/cmd/%,dist$(CMDDIR)/%,$(CMD_SRC))

MAIN_OUT := dist$(BINDIR)/genlimineconf

HOOK_INSTALL_OUT := dist$(KERNELHOOKDIR)/post-install/100-genlimineconf
HOOK_REMOVE_OUT  := dist$(KERNELHOOKDIR)/post-remove/100-genlimineconf

STATIC_OUT := dist$(CONFDIR)/options.conf

.PHONY: all clean install uninstall

all: $(MAIN_OUT) $(LIB_OUT) $(CMD_OUT) $(HOOK_INSTALL_OUT) $(HOOK_REMOVE_OUT) $(STATIC_OUT)

$(MAIN_OUT): src/main.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

dist$(LIBDIR)/%.sh: src/lib/%.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 644 $@

dist$(CMDDIR)/%.sh: src/cmd/%.sh
	@mkdir -p $(dir $@)
	$(SUBST) $< > $@
	chmod 755 $@

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
	if [ ! -d "$(DESTDIR)$(CONFDIR)" ]; then \
		cp -r dist/. "$(DESTDIR)/"; \
	else \
		mv "$(DESTDIR)$(CONFDIR)" "$(DESTDIR)$(CONFDIR).bak"; \
		cp -r dist/. "$(DESTDIR)/"; \
		rm -rf "$(DESTDIR)$(CONFDIR)"; \
		mv "$(DESTDIR)$(CONFDIR).bak" "$(DESTDIR)$(CONFDIR)"; \
	fi

uninstall:
	rm -fv "$(DESTDIR)$(BINDIR)/genlimineconf"
	rm -rfv "$(DESTDIR)$(LIBDIR)"
	rm -rfv "$(DESTDIR)$(CMDDIR)"
	rm -fv "$(DESTDIR)$(KERNELHOOKDIR)/post-install/100-genlimineconf"
	rm -fv "$(DESTDIR)$(KERNELHOOKDIR)/post-remove/100-genlimineconf"
