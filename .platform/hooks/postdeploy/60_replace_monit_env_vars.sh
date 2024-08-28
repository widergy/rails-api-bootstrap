#!/bin/bash

MONIT_SIDEKIQ_MAX_MEMORY=$(/opt/elasticbeanstalk/bin/get-config environment -k MONIT_SIDEKIQ_MAX_MEMORY)
MONIT_SIDEKIQ_CYCLES=$(/opt/elasticbeanstalk/bin/get-config environment -k MONIT_SIDEKIQ_CYCLES)

# \b matches for word boundary
# -i changes the file in-place
sudo sed -i "s/\bMONIT_SIDEKIQ_MAX_MEMORY\b/${MONIT_SIDEKIQ_MAX_MEMORY}/g" /etc/monit.d/sidekiq
sudo sed -i "s/\bMONIT_SIDEKIQ_CYCLES\b/${MONIT_SIDEKIQ_CYCLES}/g" /etc/monit.d/sidekiq

echo "---> Starting Monit service" 
sudo /bin/systemctl start monit.service
