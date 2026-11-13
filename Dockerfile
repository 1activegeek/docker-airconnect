# ---------------------------------------------------------------------------
# Build stage: compile AirConnect from source
# ---------------------------------------------------------------------------
FROM ubuntu:noble AS builder

# Pulling TARGET_ARCH from build arguments
ARG TARGETARCH

# Source of the AirConnect code. AIRCONNECT_REF can be a branch, tag or commit.
ARG AIRCONNECT_REPO=https://github.com/tunlezah/AirConnect.git
ARG AIRCONNECT_REF=master

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Grab the requested version of the source (the submodules carry the
# pre-built dependency libraries), then build both bridges for this arch
RUN ARCH="${TARGETARCH:-$(dpkg --print-architecture)}" \
    && if [ "$ARCH" = "amd64" ]; then PLATFORM=x86_64; \
       elif [ "$ARCH" = "arm64" ]; then PLATFORM=aarch64; \
       else echo "Unsupported architecture: $ARCH" && exit 1; fi \
    && git init -q /airconnect \
    && cd /airconnect \
    && git fetch -q --depth 1 "$AIRCONNECT_REPO" "${AIRCONNECT_REF:-master}" \
    && git checkout -q FETCH_HEAD \
    && git submodule update --init --depth 1 \
    && mkdir -p bin/linux/$PLATFORM /out \
    && make -C airupnp -j"$(nproc)" CC=gcc HOST=linux PLATFORM=$PLATFORM ../bin/airupnp-linux-$PLATFORM \
    && make -C aircast -j"$(nproc)" CC=gcc HOST=linux PLATFORM=$PLATFORM ../bin/aircast-linux-$PLATFORM \
    && mv bin/airupnp-linux-$PLATFORM /out/airupnp-docker \
    && mv bin/aircast-linux-$PLATFORM /out/aircast-docker \
    && chmod +x /out/airupnp-docker /out/aircast-docker

# ---------------------------------------------------------------------------
# Runtime stage
# ---------------------------------------------------------------------------
FROM lsiobase/ubuntu:noble

ENV S6_STAGE2_HOOK=/app/init.sh

# AirConnect loads OpenSSL at runtime
RUN apt-get update && apt-get install -y \
    libssl3 \
    libssl-dev
COPY root/ /
COPY /src /app

# Binaries built from source in the stage above
COPY --from=builder /out/airupnp-docker /out/aircast-docker /usr/bin/

ENTRYPOINT ["/init"]
