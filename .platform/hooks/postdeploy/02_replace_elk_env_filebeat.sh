#!/bin/bash

ELK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k ELK_ENV)
KIBANA_HOST=$(/opt/elasticbeanstalk/bin/get-config environment -k KIBANA_HOST)

# \b matches for word boundary
# -i changes the file in-place
sudo sed -i "s/\bELK_ENV\b/${ELK_ENV}/g" /etc/filebeat/filebeat.yml
sudo sed -i "s/\KIBANA_HOST\b/${KIBANA_HOST}/g" /etc/filebeat/filebeat.yml
sudo /etc/init.d/filebeat stop
sudo /etc/init.d/filebeat start
