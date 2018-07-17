[hub]: https://hub.docker.com/r/spritsail/abuild
[git]: https://github.com/spritsail/drone-abuild
[drone]: https://drone.spritsail.io/spritsail/abuild
[mbdg]: https://microbadger.com/images/spritsail/abuild

# [Spritsail/abuild][hub]
[![Layers](https://images.microbadger.com/badges/image/spritsail/abuild.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/abuild.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/abuild.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/abuild.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/abuild.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/drone-abuild/status.svg)][drone]

A plugin for [Drone CI](https://github.com/drone/drone) to build and publish Alpine Linux package APKBUILDs

## Supported tags and respective `Dockerfile` links

`latest` - [(Dockerfile)](https://github.com/spritsail/drone-abuild/blob/master/Dockerfile)

## Configuration

An example configuration of how the plugin should be configured:
```yaml
pipeline:
  build:
    image: spritsail/abuild
    privileged: true
    secrets: [ signingkey, sshkey ]
    publickey: https://mywebsite.com/pubilc-signing-key.rsa.pub
    repo_sshfs: 'user@alpine.mywebsite.com:alpine/'
    abuild: fetch checksum deps build ..
```

Alternatively:
```yaml
pipeline:
  build:
    image: spritsail/abuild
    keyname: public-signing-key
    signingkey: |
        -----BEGIN RSA PRIVATE KEY-----
        MII...
    publickey: |
        -----BEGIN PUBLIC KEY-----
        MII...
    sshkey: |
        -----BEGIN RSA PRIVATE KEY-----
        MII...
    repo_sshfs: 'user@alpine.mywebsite.com:alpine/'
```

### Available options
- `signingkey`    used to sign the APK index. _recommended_
- `publickey`     the matching public half of the signing key. _recommended_
- `sshkey`        used to authenticate ssh/rsync/sshfs. _optional_
- `keyname`       overrides/sets the name of the public & private signing keys. if not specified, the name from the `publickey` url is used _optional/required_
- `abuild`        arguments to pass to `abuild`. defaults to `-r` _optional_
