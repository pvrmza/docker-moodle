#!/bin/bash

# turn on bash's job control
set -m

#######
# clean old pid and "fix" cron
find /var/run/ -type f -iname \*.pid -delete
touch /etc/crontab  /etc/cron.d/php /etc/cron.d/moodlecron

#######
# timezone
echo $TZ > /etc/timezone && rm /etc/localtime && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata 

#######
# permission check
echo "placeholder" > /var/moodledata/placeholder
chown -R www-data:www-data /var/moodledata
find /var/moodledata -type d -exec chmod 700 {} \; 
find /var/moodledata -type f -exec chmod 600 {} \; 

chown -R root:www-data /var/www/html
find /var/www/html -type d -exec chmod 750 {} \; 
find /var/www/html -type f -exec chmod 640 {} \; 

#######
# check/move admin dir
if test -v MOODLE_admin; then
  mv /var/www/html/admin /var/www/html/$MOODLE_admin
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

  value=`echo $line | cut -d = -f 2- `
  case $value in 
    [0-9]*)        echo "\$CFG->$var=$value;" ;;
    true|false)   echo "\$CFG->$var=$value;" ;;
    *)            echo "\$CFG->$var=\"$value\";"  ;;
  esac

done < <(printenv | egrep ^MOODLE_ | sort -u) >> /var/www/html/config.php 
echo "
require_once(dirname(__FILE__) . '/lib/setup.php'); 

?>" >> /var/www/html/config.php

# start up cron
/usr/sbin/cron

# start up apache
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
