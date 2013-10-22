#!/bin/bash

MONTH=`date +%m`
YEAR=`date +%Y`

./bin/jmeter -n -t login.jmx  -l log.jtl.$MONTH.$YEAR
