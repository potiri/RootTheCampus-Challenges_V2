#!/bin/bash

DS_USER=$1
DS_PROJECT_NAME=$2
DS_START_CONTAINER=$3
DS_SHELL=$4
DS_EXPOSED_CONTAINER=$5

adduser $DS_USER
echo "$DS_USER:123456" | chpasswd

# todo: remove later
# adduser testuser
# echo "testuser:123" | chpasswd

cp /shells/$DS_SHELL /usr/bin/$DS_USER-$DS_SHELL
chmod +x /usr/bin/$DS_USER-$DS_SHELL
usermod --shell "/usr/bin/$DS_USER-$DS_SHELL" $DS_USER

echo "$DS_PROJECT_NAME" >> /home/$DS_USER/.ds_project_name
chmod 704 /home/$DS_USER/.ds_project_name
echo "$DS_START_CONTAINER" >> /home/$DS_USER/.ds_start_container
chmod 704 /home/$DS_USER/.ds_start_container

echo "$DS_EXPOSED_CONTAINER" >> /home/$DS_USER/.ds_exposed_container
chmod 704 /home/$DS_USER/.ds_exposed_container


mkdir -p /home/$DS_USER/.ssh
chown $DS_USER /home/$DS_USER/.ssh
chgrp $DS_USER /home/$DS_USER/.ssh
chmod 0700 /home/$DS_USER/.ssh
cp /authorized_keys /home/$DS_USER/.ssh/authorized_keys
chmod 444 /home/$DS_USER/.ssh/authorized_keys
echo -e "Match User $DS_USER\nPasswordAuthentication no" >> /etc/ssh/sshd_config


echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker container inspect $DS_START_CONTAINER-[a-z0-9]*" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-[a-z0-9]*.env.names --project-directory /srv/compose_projects/$DS_PROJECT_NAME -p $DS_PROJECT_NAME-[a-z0-9]* up -d --build" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker exec -it $DS_START_CONTAINER-[a-z0-9]* /bin/bash" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
# echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-[a-z0-9]*.env.names -f /srv/compose_projects/$DS_PROJECT_NAME/docker-compose.yml -p $DS_PROJECT_NAME-[a-z0-9]* down" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
#echo "$DS_USER ALL=(ALL) NOPASSWD: /bin/sh -c '/usr/bin/nohup /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-[a-z0-9]*.env.names -f /srv/compose_projects/$DS_PROJECT_NAME/docker-compose.yml -p $DS_PROJECT_NAME-[a-z0-9]* down &'" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/nohup /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-[a-z0-9]*.env.names -f /srv/compose_projects/$DS_PROJECT_NAME/docker-compose.yml -p $DS_PROJECT_NAME-[a-z0-9]* down" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker port $DS_EXPOSED_CONTAINER-[a-z0-9]*" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users