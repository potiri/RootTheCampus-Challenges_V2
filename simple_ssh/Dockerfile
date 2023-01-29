FROM ubuntu:latest

ARG SSH_PASSWORD_FLAG_1
ARG FLAG_1
ARG FLAG_2

RUN apt update && apt install openssh-server -y

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Flag 1
ARG USER=john
ARG FLAG_PATH=/home/$USER/flag1
RUN adduser $USER
RUN echo "$USER:$SSH_PASSWORD_FLAG_1" | chpasswd
RUN echo "$FLAG_1" >> $FLAG_PATH
RUN chown $USER $FLAG_PATH
RUN chgrp $USER $FLAG_PATH
RUN chmod 440 $FLAG_PATH
RUN chmod ugo-w /home/$USER


# Flag 2
ARG USER=jsec
ARG FLAG_PATH=/home/$USER/flag2
RUN adduser $USER
RUN echo "$USER:JaI2avWH63nw%c62e!asfZ9ohzq)mfqZmp3B" | chpasswd
RUN echo "$FLAG_2" >> $FLAG_PATH
RUN chown $USER $FLAG_PATH
RUN chgrp $USER $FLAG_PATH
RUN chmod 440 $FLAG_PATH
RUN chmod ugo-w /home/$USER

RUN mkdir -p /home/$USER/.ssh
RUN chown $USER /home/$USER/.ssh
RUN chgrp $USER /home/$USER/.ssh
RUN chmod 0700 /home/$USER/.ssh
COPY ./jsec_id_rsa_openssh.pub /home/$USER/.ssh/authorized_keys
RUN chmod 444 /home/$USER/.ssh/authorized_keys

RUN echo "Match User $USER\nPasswordAuthentication no" >> /etc/ssh/sshd_config


EXPOSE 22

RUN service ssh start
CMD ["/usr/sbin/sshd","-D"]