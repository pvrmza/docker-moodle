
# docker-moodle
another moodle in docker or another docker with moodle...


# Environment 
    MOODLE_DATABASE_TYPE ( $CFG->dbtype -> default -> mariadb)  
    MOODLE_DATABASE_HOST ( $CFG->dbhost -> default -> mariadb)
    MOODLE_DATABASE_PORT ( $CFG->dboption[dbport] -> default -> 3306) 
    MOODLE_DATABASE_NAME ( $CFG->dbname -> default -> moodle) 
    MOODLE_DATABASE_USER ( $CFG->dbuser -> default -> moodle) 
    MOODLE_DATABASE_PASSWORD ( $CFG->dbpass ->default -> moodle) 

    MOODLE_URL ( $CFG->wwwroot -> default -> http://127.0.0.1) 
    MOODLE_USERNAME ( $CFG->admin -> default -> admin) 

    MOODLE_PROXY ( $CFG->reverseproxy -> default ->  )
    SSL_PROXY ( $CFG->sslproxy -> default -> false )

# Volumen
	/var/moodledata
	/config

# Ports
	80 443
