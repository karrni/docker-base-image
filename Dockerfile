FROM alpine:3.18

ENV APP_DIR="/app" CONFIG_DIR="/config" PUID="1000" PGID="1000" UMASK="002" TZ="Etc/UTC"
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

RUN apk add --no-cache \
        shadow \
        bash \
        curl && \
    mkdir -p \
        "${APP_DIR}" \
        "${CONFIG_DIR}" && \
    groupmod -g 1000 users && \
    useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false user && \
    usermod -G users user

ARG S6_VERSION=3.1.5.0
ARG S6_ARCH=x86_64

RUN curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar Jpxf - -C / && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar Jpxf - -C /

COPY root/ /

ENTRYPOINT ["/init"]

