FROM ubuntu:14.04

MAINTAINER shimtom

EXPOSE 80

RUN apt-get update && apt-get install -y --no-install-recommends \
        language-pack-ja \
        ldap-account-manager \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN export LANG=ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

RUN sed -i 's,DocumentRoot .*,DocumentRoot /usr/share/ldap-account-manager,' /etc/apache2/sites-available/000-default.conf

# apache2 の出力をlogファイルへ
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log
RUN ln -sf /proc/self/fd/2 /var/log/apache2/error.log

# config files
VOLUME /var/lib/ldap-account-manager

CMD ["apache2ctl", "-DFOREGROUND"]
