FROM lsiobase/ubuntu:bionic

ENV ARCH_VAR=x86-64

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    wget \
    libssl1.0.0 \
    libssl-dev
COPY root/ /
