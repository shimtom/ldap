#!/bin/bash

set -eu

function backup() {
    dbnumber=$1
    filepath=$2

    /usr/sbin/slapcat -F /etc/ldap/slapd.d -n $dbnumber > $filepath
}

BACKUP_PATH=/ldap_data

# $LDAP_BACKUP_TTLで指定した日数を経過したファイルを削除
find $BACKUP_PATH -type f -mtime +$LDAP_BACKUP_TTL -delete

dateFileFormat="+%Y%m%dT%H%M%S"
DIR_PATH="$BACKUP_PATH/"$(date "$dateFileFormat")""

mkdir -p $DIR_PATH

backup 0 "$DIR_PATH"/config.ldif
backup 1 "$DIR_PATH"/data.ldif
chmod 600 $DIR_PATH

exit 0
