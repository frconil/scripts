#!/bin/bash


#this report analyses the results from a jmeter login script set to run every minute.
#logs are generated and rolled every month


MONTH="$1"
YEAR="$2"

if [  "$MONTH" = "" -o "$YEAR" = "" ] ; then
	echo "Usage is report_sla.sh Month Year"
	echo "no arguments given, assuming report on last month results"
	MONTH=`date --date="1 month ago" +%m` 
	YEAR=`date +%Y`
fi
LOG=log.jtl.$MONTH.$YEAR


if [ -f $LOG ] ; then 
	TOTAL=`wc -l $LOG | cut -d ' ' -f1`
	ERROR=`grep -cv "302,Moved\|200,OK" $LOG`
	SLA=`echo "($TOTAL-$ERROR)*100/$TOTAL" | bc`
	echo "SLA for `date -d \"$MONTH/01/$YEAR\" +%b\ %Y` is $SLA %" 	
else
	echo "no data recorded for `date -d \"$MONTH/01/$YEAR\" +%b\ %Y`"
fi
