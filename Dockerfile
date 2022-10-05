FROM lsiobase/ubuntu:jammy

# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    wget \
    libssl1.0.0 \
    libssl-dev
COPY root/ /

# Grab latest version of the app
RUN if [ "$ARCH_VAR" = "amd64" ]; then ARCH_VAR=x86_64; elif [ "$ARCH_VAR" = "arm64" ]; then ARCH_VAR=aarch64; fi \
    && wget -O /bin/airupnp-$ARCH_VAR https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-$ARCH_VAR \
    && chmod +x /bin/airupnp-$ARCH_VAR \
    && wget -O /bin/aircast-$ARCH_VAR https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/aircast-$ARCH_VAR \
    && chmod +x /bin/aircast-$ARCH_VAR