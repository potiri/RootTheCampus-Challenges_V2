FROM php:apache

ARG FLAG_1
ARG FLAG_2

ENV PORT 80
EXPOSE 80

WORKDIR /var/www/html/
COPY ./html .

# Flag 1
RUN mkdir bonus
RUN echo "<html>Flag 1: $FLAG_1</html>" >> bonus/index.html

# Flag 2
RUN mkdir apollo13
RUN echo "<html>Flag 2: $FLAG_2</html>" >> apollo13/index.html