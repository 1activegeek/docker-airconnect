FROM lsiobase/ubuntu:bionic

# Setting variables
ENV AIRCAST_VAR="" \
AIRUPNP_VAR=""

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    wget \
    libssl1.0.0 \
    libssl-dev
COPY root/ /
