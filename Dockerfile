FROM lsiobase/ubuntu:bionic

# Setting variables
# Using -b 0.0.0.0 as an option for a default that will run with no issues while
# allowing the user to alter these after the fact so as to expand in superisor.conf file
ENV AIRCAST_VAR="-b 0.0.0.0" \
AIRUPNP_VAR="-b 0.0.0.0"

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    wget \
    libssl1.0.0 \
    libssl-dev
COPY root/ /
