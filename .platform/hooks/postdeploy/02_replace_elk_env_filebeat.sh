# #!/bin/bash

# ELK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k ELK_ENV)

# # \b matches for word boundary
# # -i changes the file in-place
# sudo sed -i "s/\bELK_ENV\b/${ELK_ENV}/g" /etc/filebeat/filebeat.yml
# sudo /etc/init.d/filebeat stop
# sudo /etc/init.d/filebeat start
