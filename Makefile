NAME = animate.sh
NAME2 = animations.sh
ANIMDIR = $(HOME)/.local/share
PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man
VERSION ?= unknown

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

manpages: clean
	@echo Creating manpages for $(NAME).
	@mkdir -p man/man1

	@help2man -Nn "Executes a command while displaying an animation." -o man/man1/$(NAME).1 $(NAME)
	@gzip man/man1/$(NAME).1

release: version manpages

version:
	@echo Updating to new version $(VERSION)
	@sed -Ei 's/(__animations__program_version=")[^"]*(")/\1$(VERSION)\2/g' $(NAME)

clean:
	@echo Cleaning up directory.
	@rm -rf man
