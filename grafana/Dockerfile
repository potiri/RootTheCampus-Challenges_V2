FROM vulhub/grafana:8.2.6

ARG FLAG_1

USER root

RUN mkdir /secret
RUN echo "$FLAG_1" >> /secret/flag.txt

EXPOSE 3000