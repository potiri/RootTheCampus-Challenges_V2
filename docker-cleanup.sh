#!/bin/bash

# stop all remaining running containers
docker stop $(docker ps -aq)

# remove all remaining containers
docker rm $(docker ps -aq)

# down challenge containers/networks
docker compose down

# prune all unused networks
docker network prune -f