FROM kalilinux/kali-rolling

RUN apt -y update && apt -y upgrade && apt -y autoremove && apt clean
RUN apt install iputils-ping net-tools netdiscover ssh nmap ncat netcat-traditional tmux dirb -y --no-install-recommends

#USER kali
RUN apt-get update -y
RUN apt-get install -y python2

RUN apt install vim nano -y

#RUN apt -y install kali-linux-headless # create a new image with this data

CMD ["/bin/bash"]