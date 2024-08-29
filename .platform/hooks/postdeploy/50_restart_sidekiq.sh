#!/bin/bash

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)
EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
RACK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k RACK_ENV)
SIDEKIQ_PID=$(pgrep -u "$EB_APP_USER" -f sidekiq)
SIDEKIQ_LOG="${EB_APP_DEPLOY_DIR}log/sidekiq.log"
SIDEKIQ_PID_FILE="/var/pids/sidekiq.pid"

cd "$EB_APP_DEPLOY_DIR" || { echo "Error al cambiar al directorio de despliegue"; exit 1; }
 
if [ -n "$SIDEKIQ_PID" ]; then
  echo "---> Terminating existing sidekiq with PID $SIDEKIQ_PID"
  kill -TERM "$SIDEKIQ_PID"
  # wait process to get killed
  while kill -0 "$SIDEKIQ_PID" 2>/dev/null; do
    sleep 1
  done
else
  echo "---> Sidekiq is not running, PID: $SIDEKIQ_PID"
fi
 
set -xe
export $(cat /opt/elasticbeanstalk/deployment/env | xargs)
 
echo "---> Starting sidekiq"

su "$EB_APP_USER" -c "bundle exec sidekiq -e $RACK_ENV >> $SIDEKIQ_LOG 2>&1 & echo \$! > $SIDEKIQ_PID_FILE"

echo "---> Sidekiq started with PID $(cat $SIDEKIQ_PID_FILE)"
