#!/bin/bash

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`

/opt/monitoring/bin/jmeter -n -t /opt/monitoring/login.jmx  -l /var/log/monitoring/log.jtl.$DAY.$MONTH.$YEAR
