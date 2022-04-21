
# docker-moodle unattended deploy
not another moodle in docker 

Moodle is a very popular open source learning management solution (LMS) for the delivery of elearning courses and programs. It’s used not only by universities, but also by hundreds of corporations around the world who provide eLearning education for their employees. Moodle features a simple interface, drag-and-drop features, role-based permissions, deep reporting, many language translations, a well-documented API and more. With some of the biggest universities and organizations already using it, Moodle is ready to meet the needs of just about any size organization.

Site: https://moodle.org/

## Version/TAG: 
* 3.7 (3.7_STABLE 3.7.8 build 20220421) 
* 3.8 (3.8_STABLE 3.8.5+ build 20220421) 
* 3.9 (3.9_STABLE 3.9.2+ build 20220421)


## Features
- [x] All configurations can be added from environment variables to config.php
- [x] Moodle security recommendations for apache and php
- [x] Check/move admin directory
- [x] Timezone and Language setting from enviroment 
- [x] Proxy support and URL setting from enviroment 

### Config values
All environment variables starting MOODLE_ will be transformed to $CFG and added automatically to the config.php file. Double _ separates array. Example:

| Environment | Moodle Config | 
| :--- |:--- |
| MOODLE_dbhost=db | $CFG->dbhost="db"; | 
| MOODLE_apacheloguser=2 | $CFG->apacheloguser=2; | 
| MOODLE_dboptions__dbpersist=false | $CFG->dboptions['dbpersist']=false; | 
| MOODLE_dboptions__dbsocket=false | $CFG->dboptions['dbsocket']=false; | 

### Check/move admin directory
If you define MOODLE_admin ($CFG->admin) rename admin directory to MOODLE_admin

In certain circumstances you will want to move the management directory (/admin) to another location (for security or compatibility reasons)
For this you only have to define the environment variable MOODLE_admin with the name with which you want it to be renaming the directory "admin"

### URL 
The VIRTUAL_HOST and VIRTUAL_PORT variables are used with double functionality.

On the one hand they can be used for the docker with reverse proxy, but they are also used to generate the variable MOODLE_wwwroot ($CFG->wwwroot) together with the environment variable VIRTUAL_URL

MOODLE_wwwroot = $proto://$VIRTUAL_HOST:$VIRTUAL_PORT$VIRTUAL_URL

If the variable MOODLE_sslproxy is defined, $proto is https, else http
In this way, you can use VIRTUAL_URL to publish moodle in any URL, something very useful when you are behind a reverse proxy


## Deploy

### Docker Composer
- Run both database and moodle containers.
```
  $ git clone https://github.com/pvrmza/docker-moodle.git 
  $ cd docker-moodle
  $ cp env_mysql_example .env_mysql
  $ cp env_moodle_example .env_moodle
  $ docker-compose up -d
```

# Volumen
	/var/moodledata
	/var/www/html/theme
	/var/www/html/mod

# Ports
	80 
