ARG IMAGE=alpine
ARG ALPINE_TAG=3.8

FROM ${IMAGE}:${ALPINE_TAG}
ARG ALPINE_TAG

LABEL maintainer="Spritsail <drone-abuild@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="abuild" \
      org.label-schema.description="A Drone CI plugin for building and publishing Alpine Linux APKBUILDs" \
      org.label-schema.version=${VCS_REF}

COPY entrypoint /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint \
 && apk add --no-cache alpine-sdk openssh-client rsync sshfs sudo su-exec \
    \
 && mkdir -p /var/cache/distfiles \
 && chmod g+w /var/cache/distfiles \
 && chgrp abuild /var/cache/distfiles \
    \
 && if [ "$ALPINE_TAG" = edge ]; then \
       echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    fi

ENTRYPOINT ["/usr/local/bin/entrypoint"]
