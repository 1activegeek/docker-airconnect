FROM lsiobase/ubuntu:arm64v8-latest

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    wget \
    libssl1.0.0 \
    libssl-dev
COPY root/ /
