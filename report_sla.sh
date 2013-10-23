#!/bin/bash


#this report analyses the results from a jmeter login script set to run every minute.
#logs are generated and rolled every month

DAY=$1
MONTH="$2"
YEAR="$3"

if [ "$#" -ne 3 ] ; then
	echo "Usage is report_sla.sh Day Month Year"
	echo "wrong arguments given, assuming report on last day results"
	DAY=`date --date="yesterday" +%d` 
	MONTH=`date --date="yesterday" +%m` 
	YEAR=`date --date="yesterday" +%Y`
fi
LOG=/var/log/monitoring/log.jtl.$DAY.$MONTH.$YEAR


if [ -f $LOG ] ; then 
	TOTAL=`wc -l $LOG | cut -d ' ' -f1`
	ERROR=`grep -cv "302,Moved\|200,OK" $LOG`
	SLA=`echo "($TOTAL-$ERROR)*100/$TOTAL" | bc`
	echo "SLA for `date -d \"$MONTH/$DAY/$YEAR\" +%d\ %b\ %Y` is $SLA %" 	
else
	echo "no data recorded for `date -d \"$MONTH/$DAY/$YEAR\" +%d\ %b\ %Y`"
fi
