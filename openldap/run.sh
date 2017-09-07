#!/bin/bash

set -eu

function status() {
    # ステータスを標準エラーに出力
    echo "---> ${@}" >&2
}

function fix_permission() {
    # ldapサーバーに必要なディレクトリの権限を修正する.
    chown -R openldap /var/lib/ldap /etc/ldap/slapd.d
    chgrp openldap /ssl
}

function reconfigure() {
    # パッケージ設定を書き換える
    status "Configuring slapd"

    debconf-set-selections <<EOF
slapd slapd/internal/generated_adminpw password ${LDAP_ADMIN_PASSWORD}
slapd slapd/internal/adminpw password ${LDAP_ADMIN_PASSWORD}
slapd slapd/password1 password ${LDAP_ADMIN_PASSWORD}
slapd slapd/password2 password ${LDAP_ADMIN_PASSWORD}
slapd shared/organization string ${LDAP_ORGANIZATION}
slapd slapd/purge_database boolean false
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/domain string ${LDAP_DOMAIN}
EOF

    # slapdパッケージを再設定
    dpkg-reconfigure -f noninteractive slapd > /dev/null
}

function start() {
    # slapdを起動する.
    status "Start slapd"
    /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" -g openldap -u openldap -F /etc/ldap/slapd.d -d ${LDAP_LOG_LEVEL}
}

function startbg() {
    # slapdを一時的に起動する.
    status "Starting slapd ..."
    /usr/sbin/slapd -h "ldap:/// ldapi:///" -g openldap -u openldap -F /etc/ldap/slapd.d -d 0 &
    PID=$!

    # プロセスが作成されるまで待つ
    sleep 5
    while ! pgrep slapd > /dev/null; do
        sleep 1;
    done
}

function stopbg() {
    status "Stopping slapd"
    kill $PID

    # プロセスが消えるまで待つ
    while pgrep slapd > /dev/null; do
        sleep 1;
    done
}

function check_config() {
    # 設定ファイル(cn=config)の確認
    status "Check cn=config ..."
    if ! ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn 2>/dev/null >/dev/null; then
        status "Error: cn=config not found"
        exit 1
    fi
    status "found"
}

function set_config_password() {
    # root passwordを設定する
    status "Setting cn=config password"

    ldapmodify -Y external -H ldapi:/// > /dev/null <<EOF
dn: cn=config
changetype: modify

dn: olcDatabase={0}config,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $(slappasswd -s '${LDAP_ADMIN_PASSWORD}')
EOF
}

function set_certificates() {
    # SSL サーバー証明書の確認
    status "Check certificates ..."

    if test -e /ssl/${TLS_CACERTIFICATE_FILE} \
         -a -e /ssl/${TLS_CERTIFICATE_KEY_FILE} \
         -a -e /ssl/${TLS_CERTIFICATE_FILE}; then
        status "found"
        status "Setting certificates"
        chmod o= /ssl
        chgrp openldap /ssl

        ldapmodify -Y external -H ldapi:/// > /dev/null <<EOF
dn: cn=config
changetype: modify
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /ssl/${TLS_CACERTIFICATE_FILE}
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /ssl/${TLS_CERTIFICATE_KEY_FILE}
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /ssl/${TLS_CERTIFICATE_FILE}
EOF
    else
        status "no"
        echo "     to activate TLS/SSL, please install:"
        echo "       - /ssl/${TLS_CACERTIFICATE_FILE}"
        echo "       - /ssl/${TLS_CERTIFICATE_KEY_FILE}"
        echo "       - /ssl/${TLS_CERTIFICATE_FILE}"
    fi
}

function disallow_anonymous_bind() {
    # anonymous bind を禁止する.
    status "disallow anonymous bind"
    ldapmodify -Y external -H ldapi:/// > /dev/null <<EOF
dn: cn=config
changetype: modify
add: olcDisallows
olcDisallows: bind_anon

dn: olcDatabase={-1}frontend,cn=config
changetype: modify
add: olcRequires
olcRequires: authc
EOF
}



status "Configuration"
# 必要なディレクトリの権限を修正
fix_permission
# パッケージの設定を書き換える
reconfigure
# slapd を一時的に起動
startbg
# cn=configの存在を確認
check_config
# cn=configのパスワードを設定
set_config_password
check_config
# サーバー証明書の設定
set_certificates
# anonymous bindの禁止
disallow_anonymous_bind
# slapd を一時中断
stopbg
status "Configuration done."

# start

status "Starting slapd ..."
status "Administrator Password: ${LDAP_ADMIN_PASSWORD}"
start
status "slapd terminated."
