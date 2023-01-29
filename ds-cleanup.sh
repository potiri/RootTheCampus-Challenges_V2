#!/bin/bash

# stop all kali/shop running containers
#docker stop $(docker ps -aq --filter="name=^/(kali-|shop-)")
# remove all kali/shop containers
#docker rm $(docker ps -aq --filter="name=^/(kali-|shop-)")

docker ps --format "{{.ID}} {{.CreatedAt}}" --filter="name=^/(kali-|shop-)" | \
while read id cdate ctime _; \
	do if [[ $(date +%s -d "$cdate $ctime") -lt $(date +%s -d '3 hours ago') ]]; \
	then 
		docker stop $id; \
		docker rm $id; \
	fi; \
done


