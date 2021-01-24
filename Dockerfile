ARG IMAGE=alpine
ARG ALPINE_TAG=3.13

FROM ${IMAGE}:${ALPINE_TAG}
ARG ALPINE_TAG

LABEL maintainer="Spritsail <drone-abuild@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="abuild" \
      org.label-schema.description="A Drone CI plugin for building and publishing Alpine Linux APKBUILDs" \
      org.label-schema.version=${VCS_REF}

COPY --chmod=755 entrypoint /usr/local/bin/entrypoint
COPY --chmod=755 run-abuild /usr/local/bin/run-abuild

RUN apk add --no-cache \
        alpine-sdk \
        openssh-client \
        rsync \
        sshfs \
        su-exec \
        sudo \
 && install -d -g abuild -m775 /var/cache/distfiles \
    # Every version of Alpine has access to testing packages
    # Versions from main/community repos take priority though
    # Only packages _exclusively_ available in edge/testing will
    # be installed by default.
 && echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

ENTRYPOINT ["/usr/local/bin/entrypoint"]
