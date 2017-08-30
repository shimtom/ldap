# OpenLDAP Server
* Ports:
    - 389: LDAP and LDAP+startTLS
    - 636: LDAP+SSL

* Volumes
    - `/var/lib/ldap`: ldap database files
    - `/etc/ldap/slapd.d`: ldap config files
    - `/ssl`: ssl certificate files

* Environment Variables
    - `ENV LDAP_DOMAIN`
        default: example.com
    - `ENV LDAP_ORGANIZATION`
        default: Example
    - `ENV LDAP_ADMIN_PASSWORD`
        default: admin
    - `ENV LDAP_LOG_LEVEL`
        default: 256

```
$ docker run shimtom/openldap:latest
```
