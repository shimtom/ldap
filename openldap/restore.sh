#!/bin/bash

# Usage: /usr/local/bin/restore direpath
set -eu

function restore() {
    dbnumber=$1
    filepath=$2

    slapadd -c -F /etc/ldap/slapd.d -n $dbnumber -l $filepath
}

direpath=$1

service slapd stop

# restore config
rm -rf /etc/ldap/slapd.d
mkdir -p /etc/ldap/slapd.d
chown openldap:openldap /etc/ldap/slapd.d
restore 0 "$direpath"/config.ldif

# restore data
rm -rf /var/lib/ldap
mkdir -p /var/lib/ldap
chown openldap:openldap /var/lib/ldap
restore 1 "$direpath"/data.ldif

service slapd start

rm -rf $direpath

exit 0
