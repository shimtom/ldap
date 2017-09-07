# LDAP Account Manager
(LDAP Account Manager)[https://www.ldap-account-manager.org/lamcms/]のdocker image.
## Usage
```
$ docker build -t shimtom/lam:latest .
$ docker run -d --name lam -p 8080:80 shimtom/lam:latest
```
accces to http://localhost:8080

* Ports:
    - `80`: http port.

* Volumes:
    - `/var/lib/ldap-account-manager`: config files

## Backup
mount `/var/lib/ldap-account-manager` to host directory and copy this directory.

## Restore
replace docker `/var/lib/ldap-account-manager` with backuped `/var/lib/ldap-account-manager`
