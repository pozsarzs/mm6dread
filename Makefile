# +----------------------------------------------------------------------------+
# | MM6DRead v0.1 * Status reader program for MM6D device                      |
# | Copyright (C) 2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>            |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs = desktop documents languages manuals source
srcdirs = source

all:
	@echo Compiling $(name):
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo Cleaning source code:
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@echo "Source code is cleaned."

install:
	@echo Installing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Application is installed."

uninstall:
	@echo Removing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir uninstall; fi; \
	done
	@echo "Application is removed."
