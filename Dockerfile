FROM lsiobase/ubuntu:bionic

# Add Supervisor
RUN apt-get update && apt-get install -y supervisor wget
COPY root/ /

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
