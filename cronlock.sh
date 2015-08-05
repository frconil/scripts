#!/bin/bash

# A cron wrapper that use an existing postgresql db url to set up a postgresql lock and ensure non concurrent run of cronjobs
#
# set your cronjob as you would but add the following:
# x y z * *  root  /bin/cronlock.sh <TASK NAME>	my_command my args
#
# the table is created with the following (to be added as a deploy task)
#
# CREATE TABLE IF NOT EXISTS task_keys (task varchar(20) primary key,  last_executed timestamp with time zone not null,  by_worker_id integer );
#
# Task are initialised as such:
#
# INSERT INTO task_keys (task, last_executed) SELECT '<TASK NAME>', '-INFINITY' WHERE NOT EXISTS (SELECT task FROM task_keys WHERE task = '<TASK NAME>');
#
# $DB_DEFAULT_URL is a standard postgres url: postgresql://user:password@server:port/database
. /root/.cronfile

if [[ $# -lt 2  ]]; then
	echo "USAGE: $0 TASK_NAME COMMAND ARGS"
	exit 1
fi

TASK=$1
if [[ "$DB_DEFAULT_URL" == ""  ]]; then
	echo "No postgresql server specified, exiting"
	exit 1
else
#we test we can actually connect
	psql $DB_DEFAULT_URL -A -c "select 1 from task_keys WHERE task = '$TASK';"
	if [[ "$?" -ne "0" ]]; then
		echo "Could not connect to postgresql server specified, table doesn't exist or task has never been initialised, exiting"
		exit 1
	fi
fi

# we set up task and pop the first argument to keep the command as $@
shift
LOCK=`psql $DB_DEFAULT_URL -c "UPDATE task_keys SET last_executed = current_timestamp, by_worker_id=$$ WHERE task = '$TASK' AND last_executed < (current_timestamp - INTERVAL '1' MINUTE) RETURNING *;"  | grep UPDATE`

#we're assuming only one concurrent task

if [[ "$LOCK" == "UPDATE 1" ]]; then
	# we got the lock, we're calling the command inside the wrapper
	$@
fi
