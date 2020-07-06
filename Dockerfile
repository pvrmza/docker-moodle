# base
FROM ubuntu:18.04
LABEL maintainer="Pablo A. Vargas <pablo@pampa.cloud>"

# Environment
ENV DEBIAN_FRONTEND noninteractive

# update & upgrade & install base
RUN apt update && apt -y dist-upgrade && apt -y install mysql-client pwgen python-setuptools curl git unzip apache2 php php-gd libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl4 libcurl3-dev php-curl php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring php-zip php-soap cron php-ldap vim locales

#
RUN cd /tmp && git clone -b MOODLE_37_STABLE git://git.moodle.org/moodle.git --depth=1 && \
	mv /tmp/moodle/* /var/www/html/ && rm -rf /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html 
	
#
COPY files/foreground.sh /etc/apache2/foreground.sh
#
COPY files/moodle-config.php /var/www/html/config.php
COPY files/moodle-php.ini /etc/php/7.2/apache2/conf.d/moodle-php.ini
COPY files/apache-moodle.conf /etc/apache2/conf-available/apache-moodle.conf
COPY files/moodlecron /etc/cron.d/moodlecron

#
RUN chmod 0644 /etc/cron.d/moodlecron && chmod +x /etc/apache2/foreground.sh && \
    sed -ri 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g;' /etc/apache2/sites-available/*.conf && \
    a2enmod ssl && a2ensite default-ssl && a2enconf apache-moodle && echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

# Cleanup, this is ran to reduce the resulting size of the image.
RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/cache/* /var/lib/log/* /var/lib/apt/lists/*

ENV MOODLE_DATABASE_TYPE="mariadb" \ 
    MOODLE_DATABASE_HOST="mariadb" \
    MOODLE_DATABASE_PORT="3306" \
    MOODLE_DATABASE_NAME="moodle" \
    MOODLE_DATABASE_USER="moodle" \
    MOODLE_DATABASE_PASSWORD="moodle" \
    MOODLE_USERNAME="admin" \
    MOODLE_URL="http://127.0.0.1" \
    SSL_PROXY=false 


VOLUME ["/var/moodledata","/config","/var/www/html/mod"]
EXPOSE 80 443

ENTRYPOINT ["/etc/apache2/foreground.sh"]
