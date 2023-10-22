BIN := arch-secure-boot
VERSION := 0.0.1

PREFIX ?= /usr
BIN_DIR = $(DESTDIR)$(PREFIX)/bin
SHARE_DIR = $(DESTDIR)$(PREFIX)/share

.PHONY: clean
clean:
	rm -rf dist

.PHONY: install
install:
	install -Dm755 -t "$(BIN_DIR)/" $(BIN)
	install -Dm644 -t "$(DESTDIR)/etc/$(BIN)/" startup.nsh
	install -Dm644 -t "$(DESTDIR)/etc/$(BIN)/" recovery.nsh.tmpl
	install -Dm644 -t "$(DESTDIR)/etc/$(BIN)/" recovery.ascii.tmpl
	install -Dm644 -t "$(DESTDIR)/etc/$(BIN)/mkinitcpio.d" mkinitcpio.d/*
	install -Dm744 -t "$(DESTDIR)/etc/initcpio/post" initcpio-post-hooks/*
	install -Dm644 -t "$(SHARE_DIR)/libalpm/hooks" pacman-hooks/*
	install -Dm644 -t "$(SHARE_DIR)/licenses/$(BIN)/" LICENSE
	install -Dm644 -t "$(SHARE_DIR)/doc/$(BIN)/" README.md

# TODO(kdevo): consider shifting installation to mkinitcpio to arch-secure-boot script
	install -Dm644 --backup=numbered -t "$(DESTDIR)/etc/mkinitcpio.d" mkinitcpio.d/* 

.PHONY: dist
dist: clean
	mkdir -p dist
	git archive -o "dist/$(BIN)-$(VERSION).tar.gz" --format tar.gz --prefix "$(BIN)-$(VERSION)/" "$(VERSION)"
	gpg --detach-sign --armor "dist/$(BIN)-$(VERSION).tar.gz"
	rm -f "dist/$(BIN)-$(VERSION).tar.gz"
