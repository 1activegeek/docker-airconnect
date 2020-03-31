FROM amd64/debian:stable-slim

ARG OVERLAY_VERSION="v1.22.1.0"
ARG OVERLAY_ARCH="amd64"

# Add Supervisor and S6 Overlay
RUN apt-get update && apt-get -y install gnupg curl wget supervisor && apt-get clean
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz /tmp/s6-overlay.tar.gz
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz.sig /tmp/s6-overlay.tar.gz.sig
RUN curl https://keybase.io/justcontainers/key.asc | gpg --import \
    && gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz \
    && tar xfz /tmp/s6-overlay.tar.gz -C / \
    && apt-get -y purge gnupg curl \
    && apt-get -y autoremove

COPY root/ /

ENTRYPOINT ["/init"]
