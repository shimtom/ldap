# Open LDAP + LDAP Account Manager

## Usage
1. `ldap`ディレクトリに移動
    ```
    $ cd /path/to/ldap
    ```
2. `.env` ファイルを作成し,環境変数を記述する.
    使用できる環境変数は以下の通り.
    - `LDAP_DOMAIN`: ドメイン名. (default: example.com)
    - `LDAP_ORGANIZATION`: 組織名. (default: Example.com)
    - `LDAP_ADMIN_PASSWORD`: 管理者パスワード. (default: password)
    - `LDAP_LOG_LEVEL`: LDAPサーバーのログレベル. (default: 256)
    - `LDAP_BACKUP_TTL`: バックアップを実行した際にこの日数以前のバックアップファイルは削除される. (default: 15)
    - `TLS_CACERTIFICATE_FILE`: sslに使用するCA証明書のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}-ca.pem)
    - `TLS_CERTIFICATE_KEY_FILE`: sslに使用するサーバー証明書の秘密鍵のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}.key)
    - `TLS_CERTIFICATE_FILE`: sslに使用するサーバー証明書のファイル名.このファイルは`/ssl`以下に存在する場合に有効. (default: ${LDAP_DOMAIN}.crt)

3. ビルドを実行する
    ```
    $ docker-compose build
    ```
4. サービスの起動
    ```
    $ docker-compose up
    ```
    http://localhost:8080 で起動する.
    また,ldap account managerのデフォルトパスワードは`lam`となっている.

* Note: その他の変更を行いたい場合は`docker-compose.yml`を編集する.

## Backup
* コマンド
    ```
    # backup openldap
    $ docker exec openldap /usr/local/bin/backup.sh
    $ docker exec ldap_backup tar cvf /backup/ldap_data.tar /ldap_data
    # backup ldap account manager
    $ docker exec ldap_backup tar cvf /backup/lam_data.tar /var/lib/ldap-account-manager
    ```
* backup with cron
    ```
    $ sudo sh -c "echo '0 4 * * * root docker exec openldap /usr/local/bin/backup.sh && docker exec ldap_backup tar cvf /backup/ldap_data.tar /ldap_data' >> /etc/crontab"
    $ sudo sh -c "echo '0 4 * * * root docker exec ldap_backup tar cvf /backup/lam_data.tar /var/lib/ldap-account-manager' >> /etc/crontab"
    ```
    04:00 a.m.にバックアップが行われる.

## Restore
1. clean up existing containers
    ```
    $ docker-compose stop
    $ docker-compose rm
    ```
2. edit `docker-compose.yml` and set `LDAP_CONFIG_FILE` and `LDAP_DATA_FILE`
3. start containers
    ```
    $ docker-compose up
    ```
    * Note: container内で`/ldap_data/${LDAP_CONFIG_FILE}`,`/ldap_data/${LDAP_DATA_FILE}`が存在する場合にopenldapサーバーのリストアが有効となる.

4. restore lam data
    ```
    $ docker exec ldap_backup tar xvf /backup/lam_data.tar
    ```

## TLS/SSL
`TLS_CACERTIFICATE_FILE`,`TLS_CERTIFICATE_KEY_FILE`,`TLS_CERTIFICATE_FILE`で指定したCA証明書,サーバー秘密鍵,サーバー証明書を,`./ssl/`ディレクトリ以下に用意すれば,SSL通信が可能となる.

## Trouble Shooting
### SSL接続が上手くいかない場合
1. ldap account managerのサーバーアドレスが`ldaps://`で開始されているかを確認する.
2. 発行したサーバー証明書のurlとldap account managerで指定したldapサーバーのurlが一致していることを確認する.
3. 自己署名の場合、ldap account managerの`一般設定を更新`でSSL証明書をサーバーからインポートしていることを確認する.
