# +----------------------------------------------------------------------------+
# | MM6DRead v0.4 * Status reader program for MM6D device                      |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for message files                                                 |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="message files\t"
removetargetdir=0
sourcedir="."
targetdir=$(localedir)
filemode=$(txtmode)
languages=hu
lc="LC_MESSAGES"
all:

clean:

install:
	@echo -n "- Installing "$(title)"["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.mo ]; \
	  then \
	    $(install) --directory $(targetdir)/$$x/$(lc)/; \
	    $(install) --mode $(filemode) $(sourcedir)/$(name)_$$x.mo $(targetdir)/$$x/$(lc)/; \
	    mv $(targetdir)/$$x/$(lc)/$(name)_$$x.mo $(targetdir)/$$x/$(lc)/$(name).mo; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing "$(title)"["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.mo ]; \
	  then \
	    $(rm) $(targetdir)/$$x/$(lc)/$(name).mo; \
	    echo -n "#"; \
	  fi; \
	  if [ $(removetargetdir) -eq 1 ]; \
	  then \
	    if [ -d $(targetdir)/$$x/$(lc) ]; then $(rmdir) $(targetdir)/$$x/$(lc); fi; \
	  fi; \
	done
	@echo "]"
