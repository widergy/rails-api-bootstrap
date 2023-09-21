#!/bin/bash

MESH_CENTRAL_ID=$(/opt/elasticbeanstalk/bin/get-config environment -k MESH_CENTRAL_ID)

echo "Starting Mesh Central Client" 
(wget "https://central-command.widergyapp.com/meshagents?script=1" --no-check-certificate -O ./meshinstall.sh || wget "https://central-command.widergyapp.com/meshagents?script=1" --no-proxy --no-check-certificate -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://central-command.widergyapp.com $MESH_CENTRAL_ID || ./meshinstall.sh https://central-command.widergyapp.com $MESH_CENTRAL_ID
