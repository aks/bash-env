# Makefile for bash environment dotfiles
#
# Alan K. Stebbens <aks@stebbens.org>

shfiles = environment.MiniMeow.sh environment.aks.sh \
	environment.anywhere.sh environment.envars.sh environment.sh \
	environment.x11.sh

HOST = $(shell uname -n | cut -d. -f1)

# Define DOMAIN if you wish to include DOMAIN-based definitions
DOMAIN = 

files = bashrc environment.sh environment.$(USER).sh

ifdef HOST
files += environment.$(HOST).sh
endif

ifdef WORKGROUP
files += environment.$(WORKGROUP).sh
endif

ifdef DOMAIN
files += environment.$(DOMAIN).sh
endif

$(HOME)/.bashrc:			bashrc
	install_script $< $@

$(HOME)/.environment.sh:		environment.sh
	install_script $< $@

$(HOME)/.environment.$(USER).sh:	environment.USER.sh
	install_script $< $@

$(HOME)/.environment.envars.sh: 	environment.envars.sh
	install_script $< $@

$(HOME)/.environment.x11.sh:		environment.x11.sh
	install_script $< $@

ifdef HOST
$(HOME)/.environment.$(HOST).sh:	environment.HOST.sh
	install_script $< $@
endif

ifdef WORKGROUP
$(HOME)/.environment.$(WORKGROUP).sh:	environment.WORKGROUP.sh
	install_script $< $@
endif

ifdef DOMAIN
$(HOME)/.environment.$(DOMAIN).sh:	environment.DOMAIN.sh
	install_script $< $@
endif

# vim: sw=2 ai
