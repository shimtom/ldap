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
3. ビルドを実行する
    ```
    $ docker-compose build
    ```
4. サービスの起動
    ```
    $ docker-compose up
    ```
    http://localhost:8080 で起動する.
    また、ldap account managerのデフォルトパスワードは`lam`となっている.

## バックアップ
サービスを起動すれば,`ldap_backup_1`のような名前のコンテナが起動する.
```
$ docker exec -it ldap_backup_1 /bin/sh
```
でボリュームコンテナ内にアクセスできる.このコンテナ内で`/backup`にバックアップを保存する.このディレクトリはデフォルトでは`./ldap.backup`にマウントされている.
## サーバー証明書
`${LDAP_DOMAIN}-ca.crt`,`${LDAP_DOMAIN}.key`,`${LDAP_DOMAIN}.pem`を,`./ssl/`ディレクトリ以下に用意すれば、SSL通信が可能となる.ただし、`${LDAP_DOMAIN}`は`.env`で設定したドメイン名で置き換わる.また,`./ssl`は`docker-compose.yml`を編集することで位置を変更できる.
