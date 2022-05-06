#!/bin/bash

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)
EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
RACK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k RACK_ENV)
SIDEKIQ_PID=$(pgrep -u "$EB_APP_USER" -f sidekiq)
SIDEKIQ_LOG="$EB_APP_DEPLOY_DIR/log/sidekiq.log"
 
cd "$EB_APP_DEPLOY_DIR"
 
if [ -n "$SIDEKIQ_PID" ]; then
  echo "terminating existing sidekiq"
  kill -TERM "$SIDEKIQ_PID"
  # wait process to get killed
  while kill -0 "$SIDEKIQ_PID" 2>/dev/null; do
    sleep 1
  done
fi
 
set -xe
export $(cat /opt/elasticbeanstalk/deployment/env | xargs)
 
echo "starting sidekiq"
su "$EB_APP_USER" -c "bundle exec sidekiq -e $RACK_ENV > $SIDEKIQ_LOG 2>&1 & disown"
