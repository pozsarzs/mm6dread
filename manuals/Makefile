# +----------------------------------------------------------------------------+
# | MM6DRead v0.3 * Status reader program for MM6D device                      |
# | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | Makefile                                                                   |
# | Makefile for manual pages                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

languages = en

all:

clean:

install:
	@echo -n "- Installing manual files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.1 ]; \
	  then \
	    $(install) -d $(mandir)/$$x/man1; \
	    $(install) -m $(txtmode) $(name)_$$x.1 $(mandir)/$$x/man1; \
	    mv $(mandir)/$$x/man1/$(name)_$$x.1 $(mandir)/$$x/man1/$(name).1 ; \
	  fi; \
	done
	@$(install) -d $(mandir)/man1;
	@mv $(mandir)/en/man1/* $(mandir)/man1
	@rmdir $(mandir)/en/man1/
	@rmdir $(mandir)/en
	@echo "done."

uninstall:
	@echo -n "- Removing manual files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.1 ]; \
	  then \
	    $(rm) $(mandir)/$$x/man1/$(name).1; \
	  fi; \
	done
	@$(rm) $(mandir)/man1/$(name).1;
	@echo "done."

