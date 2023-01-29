FROM ubuntu:latest

RUN apt update && apt install docker.io docker-compose openssh-server sudo -y


ARG DS_CONFIG
COPY ./shells /shells/
COPY ./ssh_key/id_rsa.pub /authorized_keys
COPY ./setup-user.sh /setup-user.sh
RUN chmod +x /setup-user.sh

#DS_USER				= DS_CONFIG_ITEM[0]
#DS_PROJECT_NAME		= DS_CONFIG_ITEM[1]
#DS_START_CONTAINER		= DS_CONFIG_ITEM[2]
#DS_SHELL				= DS_CONFIG_ITEM[3]
#DS_EXPOSED_CONTAINER	= DS_CONFIG_ITEM[4]
RUN ["/bin/bash", "-c", "for item in $DS_CONFIG; do IFS=';' read -ra DS_CONFIG_ITEM <<< $item; /setup-user.sh ${DS_CONFIG_ITEM[0]} ${DS_CONFIG_ITEM[1]} ${DS_CONFIG_ITEM[2]} ${DS_CONFIG_ITEM[3]} ${DS_CONFIG_ITEM[4]}; done;"]

RUN rm /setup-user.sh
RUN rm -r /shells

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]