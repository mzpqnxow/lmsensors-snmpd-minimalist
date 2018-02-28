# snmp-lmsensors-minimalist

An example of a minimalist read-only SNMPv1 configuration for exposing lmsensors data

## Notes

This is for dummies who haven't worked with SNMP much before and don't trust it enough to enable it on their systems. This `Makefile` provides a quick way to install an snmpd configuration that exposes *only* `lmsensors` information by whitelisting the lmSensors OID to a view and assigning a non-default value for the read-only community string name

### Install
 
`$ make install`

### Uninstall
`$ make uninstall`

#### Running as root or using sudo

If you run the `make` commands as root, you will want to comment out the `SUDO := sudo` line in the `Makefile` and uncomment the `SUDO :=` line. This will cause the `Makefile` to skip sudo since most users do not have sudoers rules for the root user and sudo will not, by default, allow root to sudo to other users (or itself)
