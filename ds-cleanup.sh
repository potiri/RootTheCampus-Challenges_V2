#!/bin/bash

# stop and remove all kali-/shop- containers
docker ps --format "{{.ID}} {{.CreatedAt}}" --filter="name=^/(kali-|shop-)" | \
while read id cdate ctime _; \
	do if [[ $(date +%s -d "$cdate $ctime") -lt $(date +%s -d '3 hours ago') ]]; \
	then 
		docker stop $id; \
		docker rm $id; \
	fi; \
done

# prune unused networks
docker network prune -f
