FROM ubuntu:latest

EXPOSE 6666

RUN apt update && apt install netcat-traditional -y

ARG FLAG_1
ENV FLAG_1=$FLAG_1
ARG FLAG_2
ENV FLAG_2=$FLAG_2

COPY ./wizard.txt .

# Dirty hack to force /bin/bash for CMD command -> allows read -t
# Probably not a good idea as many unix programs depend on a POSIX sh. But it seems to work for our case
RUN ln -sf /bin/bash /bin/sh
#RUN cp /bin/bash /bin/sh
# TODO: Why does this not work
#SHELL ["/bin/bash", "-c"]

CMD while true; do nc -l -p 6666 -c '\
	printf "Here is the first flag:\n$FLAG_1"; \
	printf "\n\n" && cat wizard.txt && printf "\n\nAs a 64 bit wizard i am pretty BASEd on my first secret. Can you help me out?"; \
	read -t 0.1 message; \
	([ x"$message" = x"$(echo "$FLAG_1" | base64)" ] && printf "\n\nGreat job, here is the second flag:\n$(echo -n "$FLAG_2" | od -A n -t x1)") \
	|| (printf "\n\n" && ([ x"$message" != x"" ] && printf "Fast enough but incorrect!" \
	|| printf "Sry to slow..."))'; \
done
