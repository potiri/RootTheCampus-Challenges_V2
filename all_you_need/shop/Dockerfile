FROM php:apache

ENV PORT 7711
ARG SSH_PASSWORD
ARG FLAG_1
ARG FLAG_2
ARG FLAG_3

EXPOSE 80
EXPOSE 22

COPY ./html /var/www/html/

#python3 python3-pip
RUN apt update && apt install openssh-server vim iputils-ping python2 cron wget sudo -y
RUN apt-get install -y libssh2-1 libssh2-1-dev
RUN pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2

RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python2 get-pip.py
RUN rm get-pip.py
# TODO: add pip to path for simplification?
#ENV PATH="$PATH:/usr/local/bin"


#RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Flag 1
ARG USER=w00d
ARG FLAG_PATH=/home/$USER/flag1
RUN adduser $USER
RUN echo "$USER:$SSH_PASSWORD" | chpasswd
RUN echo "$FLAG_1" >> $FLAG_PATH
RUN chown $USER $FLAG_PATH
RUN chgrp $USER $FLAG_PATH
RUN chmod 640 $FLAG_PATH

RUN usermod --shell "/usr/bin/python2" $USER


# Flag 2
ARG USER=sec-sys
ARG FLAG_PATH=/home/$USER/flag2
RUN adduser $USER
RUN echo "$USER:nQ35afeF9Sf142uw2ehD231!" | chpasswd
RUN echo "$FLAG_2" >> $FLAG_PATH
RUN chown $USER $FLAG_PATH
RUN chgrp $USER $FLAG_PATH
RUN chmod 640 $FLAG_PATH

RUN echo "#!/usr/bin/python2\nimport datetime\nopen('/tmp/sec-result','w').write(datetime.datetime.now().strftime('%H:%M:%S') + ' | status=ok')" >> /usr/bin/.sec-check.py
RUN chown $USER /usr/bin/.sec-check.py
RUN chgrp $USER /usr/bin/.sec-check.py
RUN chmod 646 /usr/bin/.sec-check.py
RUN echo "*/1 * * * * python2 /usr/bin/.sec-check.py" | crontab -u sec-sys - 


# Flag 3
ARG USER=sec-sys
RUN echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/pip install *" | EDITOR='tee -a' visudo

ARG FLAG_PATH=/flag3
RUN echo "$FLAG_3" >> $FLAG_PATH
RUN chown root $FLAG_PATH
RUN chgrp root $FLAG_PATH
RUN chmod 640 $FLAG_PATH


# set http port
RUN sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
# start services
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]