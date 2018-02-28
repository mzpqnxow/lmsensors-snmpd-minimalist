#!/bin/bash
CURDIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
SNMPD_CONF := /etc/snmp/snmpd.conf
APT_SNMP := snmp snmp-mibs-downloader
APT_SNMPD := snmpd
DEFAULT_COMMUNITY_STRING := public
COMMUNITY_STRING := wesleysnipes
HOSTNAME := `hostname`
LMSENSORS_OID := 1.3.6.1.4.1.2021.13.16
# If you're not root, use this line
SUDO := sudo
# If you are root, use the next time
# SUDO := 
APT_INSTALL := $(SUDO) apt-get -y install
APT_UNINSTALL := $(SUDO) apt-get -y remove --purge

all:
	@echo Please invoke with \`make install\` or \`make uninstall\`

install:
	@echo '--- Installing minimalist snmpd configuration for lmsensors data'
	@echo
	@echo '    This process will do a few simple things:'
	@echo '     1. Install the necessary apt packages'
	@echo '     2. Log the output of the default snmpd.conf for later perusal'
	@echo '     3. Overwrite the (permissive) default snmpd.conf file with one specific to lmSensors'
	@echo '     4. Restart the SNMP daemon'
	@echo
	@echo -n '--- Press enter to continue, Ctrl-C to quit ? [Enter] '
	@read _
	@echo
	@sudo apt-get -y update && \
          $(APT_INSTALL) $(APT_SNMP) && \
          sudo $(APT_INSTALL) $(APT_SNMPD) && \
          sudo cp $(CURDIR)$(SNMPD_CONF) $(SNMPD_CONF) && \
          sed -e 's/__COMMSTR__/$(COMMUNITY_STRING)/g' $(CURDIR)$(SNMPD_CONF) | sudo tee $(SNMPD_CONF) && \
          sudo service snmpd restart
	@echo
	@echo '--- Done !! ---'
	@echo
	@echo 'Test out things using the following command within your LAN or on localhost:'
	@echo "  $$ snmpwalk  -c wesleysnipes -v 1 $(HOSTNAME) $(LMSENSORS_OID)"
	@echo
	@echo 'To confirm no other MIB information is exposed, use the following command:'
	@echo "  $$ snmpwalk -c wesleysnipes -v 1 $(HOSTNAME) ."
	@echo
	@echo '--- FIN'

clean: uninstall

uninstall:
	@$(APT_UNINSTALL) $(APT_SNMP) $(APT_SNMPD)

.PHONY:	all install uninstall clean
