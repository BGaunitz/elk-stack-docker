#! /bin/bash -e
mkdir -p /var/log/testlogs

while :
do
	echo $(date -Is -u) "Test log entry!" >> /var/log/testlogs/test.log
	sleep 1
done
