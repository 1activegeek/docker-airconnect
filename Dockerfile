FROM lsiobase/ubuntu:noble

# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH
ENV S6_STAGE2_HOOK=/app/init.sh

# Add Supervisor
RUN apt-get update && apt-get install -y \
    libssl3 \
    libssl-dev \
    unzip
COPY root/ /
COPY /src /app

# Grab latest version of the app, extract binaries, cleanup tmp dir
RUN if [ "$ARCH_VAR" = "amd64" ]; then ARCH_VAR=linux-x86_64; elif [ "$ARCH_VAR" = "arm64" ]; then ARCH_VAR=linux-aarch64; fi \
    && curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest | grep browser_download_url | cut -d '"' -f 4 | xargs curl -L -o airconnect.zip \
    && unzip airconnect.zip -d /tmp/ \
    && mv /tmp/airupnp-$ARCH_VAR /usr/bin/airupnp-docker \
    && mv /tmp/aircast-$ARCH_VAR /usr/bin/aircast-docker \
    && chmod +x /usr/bin/airupnp-docker \
    && chmod +x /usr/bin/aircast-docker \
    && rm -r /tmp/*

ENTRYPOINT ["/init"]
