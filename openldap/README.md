# OpenLDAP Server

## Usage
### start
```
$ docker build -t shimtom/openldap:latest .
$ docker run -d --name openldap shimtom/openldap:latest
```

* Ports:
    - 389: LDAP and LDAP+startTLS
    - 636: LDAP+SSL

* Volumes
    - `/ldap_data`: ldap backup directory
    - `/ssl`: ssl certificate files

* Environment Variables
    - `LDAP_DOMAIN`: ドメイン名. (default: example.com)
    - `LDAP_ORGANIZATION`: 組織名. (default: Example.com)
    - `LDAP_ADMIN_PASSWORD`: 管理者パスワード. (default: password)
    - `LDAP_LOG_LEVEL`: LDAPサーバーのログレベル. (default: 256)
    - `LDAP_BACKUP_TTL`: バックアップを実行した際にこの日数以前のバックアップファイルは削除される. (default: 15)
    - `TLS_CACERTIFICATE_FILE`: sslに使用するCA証明書のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}-ca.pem)
    - `TLS_CERTIFICATE_KEY_FILE`: sslに使用するサーバー証明書の秘密鍵のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}.key)
    - `TLS_CERTIFICATE_FILE`: sslに使用するサーバー証明書のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}.crt)
    - `LDAP_CONFIG_FILE`: /ldap_data/${LDAP_CONFIG_FILE} が存在する場合にopenldapサーバーの設定ファイルとして読み込む. (default: config.ldif)
    - LDAP_DATA_FILE: /ldap_data/${LDAP_DATA_FILE} が存在する場合にopenldapサーバーのデータとして読み込む. (default: data.ldif)

### backup
```
$ docker exec openldap /usr/local/bin/backup.sh
```
データは`/ldap_data/%Y%m%dT%H%M%S`に保存される.また,`LDAP_BACKUP_TTL`で指定した日数が経過すると,次回バックアップ時にそのファイルは削除される.

### restore
```
$ docker run -d --name openldap -e LDAP_CONFIG_FILE=config.ldif -e LDAP_CONFIG_FILE=data.ldif -v ./ldap_data:/ldap_data shimtom/openldap:latest
```
