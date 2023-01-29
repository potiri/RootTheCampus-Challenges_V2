#!/bin/bash

service cron start
service ssh start
#service apache2 start
/usr/sbin/apachectl -D FOREGROUND
#tail -f /dev/null