FROM php:apache

ARG FLAG_1
ARG FLAG_2
ARG FLAG_3

ENV PORT 80
EXPOSE 80

WORKDIR /var/www
COPY ./html ./html

# Flag 1
RUN echo "$FLAG_1" > flag1

# Flag 2
RUN mkdir flagger
RUN echo "flag 2: $FLAG_2" > flagger/flag2

#Flag 3
RUN echo "<?php\n	//flag 3: $FLAG_3;\n?>" > html/flag3.php