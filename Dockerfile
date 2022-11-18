FROM lsiobase/ubuntu:jammy

# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    libssl3 \
    libssl-dev
COPY root/ /

# Grab latest version of the app, extract binaries, cleanup tmp dir
RUN if [ "$ARCH_VAR" = "amd64" ]; then ARCH_VAR=linux-x86_64; elif [ "$ARCH_VAR" = "arm64" ]; then ARCH_VAR=linux-aarch64; fi \
    && curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest | grep tarball_url | cut -d '"' -f 4 | xargs curl -L -o airconnect.tar.gz \
    && tar -xzf airconnect.tar.gz -C /tmp/ \
    && mv /tmp/philippe44-AirConnect*/bin/airupnp-$ARCH_VAR /bin/airupnp-$ARCH_VAR \
    && mv /tmp/philippe44-AirConnect*/bin/aircast-$ARCH_VAR /bin/aircast-$ARCH_VAR \
    && chmod +x /bin/airupnp-$ARCH_VAR \
    && chmod +x /bin/aircast-$ARCH_VAR \
    && rm -r /tmp/*