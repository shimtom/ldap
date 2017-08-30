FROM ubuntu:16.04

MAINTAINER shimtom

# 389: LDAP (unsecured or TLS-secured using STARTTLS)
# 636: LDAP (secured using TLS)
EXPOSE 389
EXPOSE 636

ENV LDAP_DOMAIN=example.com
ENV LDAP_ORGANIZATION=Example
ENV LDAP_ADMIN_PASSWORD=password
ENV LDAP_LOG_LEVEL=${LDAP_LOG_LEVEL:-256}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        slapd \
        ldap-utils \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /ssl
RUN chmod o= /ssl
RUN chgrp openldap /ssl


ADD run.sh /run.sh
CMD /run.sh

# LDAP database files
VOLUME ["/var/lib/ldap"]
# LDAP config files
VOLUME ["/etc/ldap/slapd.d"]
# SSL certificate files
VOLUME ["/ssl"]
