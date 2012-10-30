#!/bin/bash
#no snmp or monitoring available, needed a 5min fix to a recurring problem

var1=`df -h | grep dbus | awk ' {print $5 } '  | sed "s/\%//" `
if [ "$var1" -gt  "80" ]; then
        `echo "disk over 80% usage. Call hosting company" | mail support -s "disk full on VPS"`
        fi
        
        
