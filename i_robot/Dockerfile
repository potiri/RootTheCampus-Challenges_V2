FROM php:apache

ARG FLAG_1
ARG FLAG_2

ENV PORT 80
EXPOSE 80

WORKDIR /var/www/html/

COPY ./html .

# Flag 1
RUN mkdir -p users/john
RUN echo "<html>Flag 1: $FLAG_1</html>" > users/john/index.html

#Flag 2
RUN mkdir -p users/god
RUN echo "<html>Flag 2: $(echo "$FLAG_2" | base64)</html>" > users/god/index.html