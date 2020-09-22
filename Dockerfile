# base
FROM ubuntu:18.04
LABEL maintainer="Pablo A. Vargas <pablo@pampa.cloud>"

# Environment
ENV DEBIAN_FRONTEND noninteractive

# update & upgrade & install base
RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php php-gd libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl4 libcurl3-dev php-curl php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring php-zip php-soap cron php-ldap vim locales

#

RUN cd /tmp && git clone -b MOODLE_39_STABLE git://git.moodle.org/moodle.git --depth=1 && \
	mv /tmp/moodle/* /var/www/html/ && rm -rf /var/www/html/index.html && \
	chown -R root:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 750 {} \;  && \
    find /var/www/html -type f -exec chmod 640 {} \; 

	
#
COPY files/foreground.sh /etc/foreground.sh
#
COPY files/moodle-php.ini /etc/php/7.2/apache2/conf.d/moodle-php.ini
COPY files/apache-moodle.conf /etc/apache2/conf-enabled/apache-moodle.conf
COPY files/moodlecron /etc/cron.d/moodlecron

#
RUN chmod 0644 /etc/cron.d/moodlecron ; \
    chmod +x /etc/foreground.sh ; \
    cd /var/log/apache2/ ; for i in *log; do rm $i; ln -s /dev/stdout $i;done ; \
    echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf

# Cleanup, this is ran to reduce the resulting size of the image.
RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/cache/* /var/lib/log/* /var/lib/apt/lists/*


VOLUME ["/var/moodledata","/var/www/html/theme","/var/www/html/mod"]
EXPOSE 80 443

ENV MOODLE_VER=3.9

ENTRYPOINT ["/etc/foreground.sh"]
