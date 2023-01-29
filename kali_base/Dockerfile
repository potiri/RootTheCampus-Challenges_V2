FROM kalilinux/kali-rolling

RUN apt -y update && apt -y upgrade && apt -y autoremove && apt clean
# ncat probably not needed
RUN apt install iputils-ping net-tools netdiscover ssh nmap ncat netcat-traditional tmux -y --no-install-recommends
#RUN apt -y install kali-linux-headless # create a new image with this data

CMD ["/bin/bash"]