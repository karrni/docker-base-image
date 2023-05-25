FROM alpine:3.18

ENV APP_DIR="/app" DATA_DIR="/data" CONFIG_DIR="/config" ARGS=""
ENV PUID="1000" PGID="1000" UMASK="002" TZ="Etc/UTC"
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

# Install packages

RUN apk add --no-cache \
        shadow \
        bash \
        curl

# Create folders and user

RUN mkdir -p \
        "${APP_DIR}" \
        "${DATA_DIR}" \
        "${CONFIG_DIR}" && \
    useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false user && \
    usermod -G users user

# Install s6-overlay

ARG S6_VERSION=3.1.3.0

RUN curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-x86_64.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C /

ENTRYPOINT ["/init"]

