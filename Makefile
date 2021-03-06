# Parameters
HOMEDIR = $(shell cd && pwd)
TEMPDIR = tmp

# Targets
INSTALLS = install-rsync
COMMANDS = $(INSTALLS) import uninstall
TESTS    = $(addprefix test-,$(COMMANDS))

.PHONY: clean install $(COMMANDS) test-install $(TESTS)

clean:
	rm -rf $(TEMPDIR)

$(TEMPDIR):
	mkdir -p $(TEMPDIR)

install: install-rsync

install-rsync:
	bin/install-rsync src $(HOMEDIR)

import:
	bin/foreach-installed src $(HOMEDIR) 'cp -ra $$1 $$0/'

uninstall:
	bin/foreach-installed src $(HOMEDIR) 'rm -r $$1'

test-install: test-install-rsync

test-install-rsync: clean $(TEMPDIR)
	bin/install-rsync src $(TEMPDIR)

test-import: clean $(TEMPDIR)
	cp -ra src/. $(TEMPDIR)
	bin/foreach-installed src $(HOMEDIR) 'cp -ra $$1 $(TEMPDIR)/'

test-uninstall: clean $(TEMPDIR)
	cp -ra src/. $(TEMPDIR)
	bin/foreach-installed src $(TEMPDIR) 'rm -r $$1'
