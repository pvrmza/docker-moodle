#!/bin/bash

# turn on bash's job control
set -m

#######
# clean old pid and "fix" cron
find /var/run/ -type f -iname \*.pid -delete
touch /etc/crontab  /etc/cron.d/php /etc/cron.d/moodlecron

#######
# timezone
if test -v TZ; then
  echo $TZ > /etc/timezone 
  rm /etc/localtime &&  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata 

  echo "date.timezone=$TZ" > /etc/php/7.2/apache2/conf.d/99_datatime.ini 
fi
#######
# LANG
if test -v MOODLE_lang; then
  if ! test -d /var/www/html/lang/$MOODLE_lang; then
    mkdir -p cd $MOODLE_dataroot/lang && cd $MOODLE_dataroot/lang/
    wget https://download.moodle.org/download.php/direct/langpack/$MOODLE_VER/$MOODLE_lang.zip -q -O /tmp/temp.zip && unzip /tmp/temp.zip && rm -rf /tmp/temp.zip
    apt-get update && apt-get -y install language-pack-$MOODLE_lang && dpkg-reconfigure locales 
  fi
fi

#######
# Building URL
if test -v VIRTUAL_URL; then
  # Apache conf
  echo -e "\nAlias $VIRTUAL_URL /var/www/html \n" > /etc/apache2/conf-available/apache-moodle.conf
fi

if test -v MOODLE_sslproxy; then
  proto=https
  export MOODLE_reverseproxy=true
else
  proto=http
fi

export MOODLE_wwwroot=$proto://$VIRTUAL_HOST:$VIRTUAL_PORT$VIRTUAL_URL


#######
# check/move admin dir
if test -v MOODLE_admin; then
  admin_dir=$(find /var/www/html/ -iname admin_settings_search_form.php | xargs dirname)
  mv $admin_dir /var/www/html/$MOODLE_admin 2>/dev/null
fi

#######
# ENVIRONMENT to CONFIG
rm -rf /var/www/html/config.php 
echo "<?php
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();
" > /var/www/html/config.php

while IFS= read -r line
do
  key=`echo $line | cut -d = -f 1 |sed "s/MOODLE_//g"`
  if test $(echo $key | egrep __) ; then
    var=`echo $key | sed "s/__/['/g" | sed "s/$/']/g" `
  else
    var=$key
  fi

  value=`echo $line | cut -d = -f 2- |sed 's/\"//g'`
  case $value in 
    [0-9]*)        echo "\$CFG->$var=$value;" ;;
    true|false)   echo "\$CFG->$var=$value;" ;;
    *)            echo "\$CFG->$var=\"$value\";"  ;;
  esac

done < <(printenv | egrep ^MOODLE_ | sort -u) >> /var/www/html/config.php 

echo "
require_once(dirname(__FILE__) . '/lib/setup.php'); 

?>" >> /var/www/html/config.php

#######
# permission check
echo "Check permission in $MOODLE_dataroot... "
echo "placeholder" > $MOODLE_dataroot/placeholder
chown -R www-data:www-data $MOODLE_dataroot
find $MOODLE_dataroot -type d -exec chmod 700 {} \; 
find $MOODLE_dataroot -type f -exec chmod 600 {} \; 

echo "Check permission in www-root... "
chown -R root:www-data /var/www/html
find /var/www/html -type d -exec chmod 750 {} \; 
find /var/www/html -type f -exec chmod 640 {} \; 


# start up cron
/usr/sbin/cron

# start up apache
source /etc/apache2/envvars
exec apache2 -D FOREGROUND

