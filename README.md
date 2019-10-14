
# docker-moodle
another moodle in docker or another docker with moodle...


# Environment 
| **MOODLE_DATABASE_TYPE** | $CFG->dbtype | mariadb | 'pgsql', 'mariadb', 'mysqli', 'mssql', 'sqlsrv' or 'oci' |  
| **MOODLE_DATABASE_HOST** | $CFG->dbhost | mariadb | 'localhost' or 'db.isp.com' or IP |
| **MOODLE_DATABASE_PORT** | $CFG->dboption[dbport] | 3306 | the TCP port number to use when connecting to the server |
| **MOODLE_DATABASE_NAME** | $CFG->dbname | moodle | database name, eg moodle |  
| **MOODLE_DATABASE_USER** | $CFG->dbuser | moodle | your database username |  
| **MOODLE_DATABASE_PASSWORD** | $CFG->dbpass | moodle | your database password |
| **MOODLE_URL** | $CFG->wwwroot | http://127.0.0.1 | The full web address where moodle was installed, server name and directory. The directory can be the root or / moodle |  
| **MOODLE_USERNAME** | $CFG->admin | admin |  |  
| **MOODLE_PROXY** | $CFG->reverseproxy |   | Enable when using external proxy  | 
| **SSL_PROXY** | $CFG->sslproxy | false  | Enable when using external SSL appliance | 

# Volumen
	/var/moodledata
	/config

# Ports
	80 443
