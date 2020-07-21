
# docker-moodle unattended deploy
not another moodle in docker 

Moodle is a very popular open source learning management solution (LMS) for the delivery of elearning courses and programs. It’s used not only by universities, but also by hundreds of corporations around the world who provide eLearning education for their employees. Moodle features a simple interface, drag-and-drop features, role-based permissions, deep reporting, many language translations, a well-documented API and more. With some of the biggest universities and organizations already using it, Moodle is ready to meet the needs of just about any size organization.

Site: https://moodle.org/

## Features
* All configurations can be added from environment variables
* Moodle security recommendations for apache and php
* Check/move admin directory
* Version: 3.7 (STABLE) / 3.8 (STABLE) / 3.9 (STABLE)

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

## Deploy

### Docker Composer
- Run both database and moodle containers.
```
  $ git clone https://github.com/pvrmza/docker-moodle.git 
  $ cd docker-moodle
  $ cp env_mysql_example .env_mysql
  $ cp env_moodle_example .env_observium
  $ docker-compose up
```

# Volumen
	/var/moodledata
	/var/www/html/theme
	/var/www/html/mod

# Ports
	80 
