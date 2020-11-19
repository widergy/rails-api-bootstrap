# #!/bin/bash

# EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
# EB_APP_PID_DIR="/var/pids"

# SIDEKIQ_PID=$EB_APP_PID_DIR/sidekiq.pid
# if [ -f $SIDEKIQ_PID ]
# then
#   echo "TSTP/quieting sidekiq"
#   su -s /bin/bash -c "kill -TSTP `cat $SIDEKIQ_PID`" $EB_APP_USER
# fi
