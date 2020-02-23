ARG IMAGE=alpine
ARG ALPINE_TAG=3.11

FROM ${IMAGE}:${ALPINE_TAG}
ARG ALPINE_TAG

LABEL maintainer="Spritsail <drone-abuild@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="abuild" \
      org.label-schema.description="A Drone CI plugin for building and publishing Alpine Linux APKBUILDs" \
      org.label-schema.version=${VCS_REF}

COPY entrypoint /usr/local/bin/entrypoint
COPY run-abuild /usr/local/bin/run-abuild

RUN chmod +x /usr/local/bin/entrypoint /usr/local/bin/run-abuild \
 && apk add --no-cache alpine-sdk openssh-client rsync sshfs sudo su-exec \
    \
 && mkdir -p /var/cache/distfiles \
 && chmod g+w /var/cache/distfiles \
 && chgrp abuild /var/cache/distfiles \
    \
    # Every version of Alpine has access to testing packages
    # Versions from main/community repos take priority though
    # Only packages _exclusively_ available in edge/testing will
    # be installed by default.
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

ENTRYPOINT ["/usr/local/bin/entrypoint"]
