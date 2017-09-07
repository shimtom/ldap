FROM ubuntu:16.04

MAINTAINER shimtom

# 389: LDAP (unsecured or TLS-secured using STARTTLS)
# 636: LDAP (secured using TLS)
EXPOSE 389
EXPOSE 636

ENV LDAP_DOMAIN=example.com
ENV LDAP_ORGANIZATION=Example.com
ENV LDAP_ADMIN_PASSWORD=password
ENV LDAP_LOG_LEVEL=${LDAP_LOG_LEVEL:-256}
ENV LDAP_BACKUP_TTL=15
ENV TLS_CACERTIFICATE_FILE=${LDAP_DOMAIN}-ca.pem
ENV TLS_CERTIFICATE_KEY_FILE=${LDAP_DOMAIN}.key
ENV TLS_CERTIFICATE_FILE=${LDAP_DOMAIN}.crt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        slapd \
        ldap-utils \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /ssl
RUN chmod o= /ssl
RUN chgrp openldap /ssl

ADD backup.sh /usr/local/bin
ADD restore.sh /usr/local/bin
ADD run.sh /usr/local/bin

CMD /usr/local/bin/run.sh

# LDAP backup directory
VOLUME ["/ldap_data"]
# SSL certificate files
VOLUME ["/ssl"]
