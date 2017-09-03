# Open LDAP + LDAP Account Manager

## Usage
1. `ldap`ディレクトリに移動
    ```
    $ cd /path/to/ldap
    ```
2. `.env` ファイルを作成し、環境変数を記述する.
    使用できる環境変数は以下の通り.
    * `LDAP_DOMAIN`: ドメイン名. (default: example.com)
    * `LDAP_ORGANIZATION`: 組織名. (default: Example)
    * `LDAP_ADMIN_PASSWORD`: 管理者パスワード. (default: password)
    * `LDAP_LOG_LEVEL`: LDAPサーバーのログレベル. (default: 256)
    * `LDAP_BACKUP_TTL`: バックアップを実行した際にこの日数以前のバックアップファイルは削除される. (default: 15)
3. ビルドを実行する
    ```
    $ docker-compose build
    ```
4. サービスの起動
    ```
    $ docker-compose up
    ```
    http://localhost:8080 で起動する.
    また、ldap account managerのデフォルトパスワードは`lam`となっている.

## バックアップ
```
$ docker exec openldap /usr/local/bin/backup.sh
$ docker exec ldap_backup tar cvf /backup/ldap_data.tar /ldap_data
$ docker exec ldap_backup tar cvf /backup/lam_data.tar /var/lib/ldap-account-manager
```

## リストア
```
$ docker exec ldap_backup tar xvf /backup/ldap_data.tar
$ docker exec openldap /usr/local/bin/restore.sh /ldap_data/%Y%m%dT%H%M%S
$ docker exec ldap_backup tar xvf /backup/lam_data.tar
```

`%Y%m%dT%H%M%S`はディレクトリ名に変更する.

## サーバー証明書
`${LDAP_DOMAIN}-ca.crt`,`${LDAP_DOMAIN}.key`,`${LDAP_DOMAIN}.pem`を,`./ssl/`ディレクトリ以下に用意すれば、SSL通信が可能となる.ただし、`${LDAP_DOMAIN}`は`.env`で設定したドメイン名で置き換わる.また,`./ssl`は`docker-compose.yml`を編集することで位置を変更できる.
