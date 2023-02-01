#!/bin/bash

# define vars
DS_USER=$1
DS_PROJECT_NAME=$2
DS_START_CONTAINER=$3
DS_SHELL=$4
DS_EXPOSED_CONTAINER=$5
# just a placeholder for session token (sh-ssh -> len = 10) -> [a-z0-9][a-z0-9]...
DS_TOKEN_PLACEHOLDER=$(printf '[a-z0-9]%.0s' {1..10})


# create challenge user
adduser $DS_USER
echo "$DS_USER:TvPV!8Y2A6jSwUKh" | chpasswd
cp /shells/$DS_SHELL /usr/bin/$DS_USER-$DS_SHELL
chmod +x /usr/bin/$DS_USER-$DS_SHELL
usermod --shell "/usr/bin/$DS_USER-$DS_SHELL" $DS_USER

cd /home/$DS_USER/
# set up ssh
mkdir -p .ssh
chown $DS_USER .ssh
chgrp $DS_USER .ssh
chmod 0700 .ssh
cp /authorized_keys .ssh/authorized_keys
chmod 444 .ssh/authorized_keys
echo -e "Match User $DS_USER\nPasswordAuthentication no" >> /etc/ssh/sshd_config

# create some configuration files
echo "$DS_PROJECT_NAME" > .ds_project_name
chown $DS_USER .ds_project_name
chgrp $DS_USER .ds_project_name
chmod 400 .ds_project_name

echo "$DS_START_CONTAINER" > .ds_start_container
chown $DS_USER .ds_start_container
chgrp $DS_USER .ds_start_container
chmod 400 .ds_start_container

echo "$DS_EXPOSED_CONTAINER" > .ds_exposed_container
chown $DS_USER .ds_exposed_container
chgrp $DS_USER .ds_exposed_container
chmod 400 .ds_exposed_container

# create some sudo rules
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker container inspect $DS_START_CONTAINER-$DS_TOKEN_PLACEHOLDER" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-$DS_TOKEN_PLACEHOLDER.env.names --project-directory /srv/compose_projects/$DS_PROJECT_NAME -p $DS_PROJECT_NAME-$DS_TOKEN_PLACEHOLDER up -d --build" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker exec -it $DS_START_CONTAINER-$DS_TOKEN_PLACEHOLDER /bin/bash" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/nohup /usr/bin/docker-compose --env-file /tmp/$DS_PROJECT_NAME-$DS_TOKEN_PLACEHOLDER.env.names -f /srv/compose_projects/$DS_PROJECT_NAME/docker-compose.yml -p $DS_PROJECT_NAME-$DS_TOKEN_PLACEHOLDER down" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users
echo "$DS_USER ALL=(ALL) NOPASSWD: /usr/bin/docker port $DS_EXPOSED_CONTAINER-$DS_TOKEN_PLACEHOLDER" | EDITOR='tee -a' visudo -f /etc/sudoers.d/ds_users