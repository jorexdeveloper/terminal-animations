NAME = tan
NAME2 = tan.sh
ANIMDIR = $(HOME)/.local/share
PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man
VERSION ?= 1.0.0

all:
	@echo Run 'make install' to install $(NAME)

install:
	@echo Installing $(NAME).
	@mkdir -p $(HOME) $(DESTDIR)$(PREFIX)/bin
	@cp -p $(NAME) $(DESTDIR)$(PREFIX)/bin
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/$(NAME)

	@echo Installing manual pages.
	@mkdir -p $(DESTDIR)$(MANDIR)
	@cp -rp man/man1 $(DESTDIR)$(MANDIR)

	@echo Installing default animations.
	@mkdir -p $(DESTDIR)$(ANIMDIR)
	@cp -rp animations $(DESTDIR)$(ANIMDIR)

uninstall:
	@echo Uninstalling $(NAME).
	@rm -rvf $(DESTDIR)$(PREFIX)/bin/$(NAME)
	@rm -rvf $(DESTDIR)$(MANDIR)/man1/$(NAME).1* $(DESTDIR)$(ANIMDIR)/animations

manpages:
	@echo Creating manpages for $(NAME).
	@rm -rf man
	@mkdir -p man/man1

	@help2man -Nn "Shows an animation while executing a given command." -o man/man1/$(NAME).1 $(NAME)
	@gzip man/man1/$(NAME).1

release: version manpages

version:
	@echo Updating $(NAME2)
	@sed -E '1s/.*/# To be sourced during shell initialization/; 2s/(SC1090)/\1,SC2148/; s/$(NAME)\s{3}/$(NAME2)/; s/(^\s*__animations__program_name=").+(")$$/\1$(NAME)\2/; $$s/^/# /' $(NAME) >$(NAME2)

	@echo Updating to new version $(VERSION)
	@sed -Ei 's/(__animations__program_version=")[^"]*(")/\1$(VERSION)\2/g' $(NAME) $(NAME2)
