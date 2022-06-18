repo = "spritsail/abuild"
archs = ["amd64", "arm64"]
branches = ["master"]
versions = {
  "3.14": [],
  "3.15": [],
  "3.16": ["latest"],
  "edge": [],
}

def main(ctx):
  builds = []

  for ver, tags in versions.items():
    depends_on = []
    for arch in archs:
      key = "build-%s-%s" % (ver, arch)
      builds.append(step(ver, arch, key))
      depends_on.append(key)

    if ctx.build.branch in branches:
      builds.append(publish(ver, depends_on, tags))

  return builds

def step(ver, arch, key):
  return {
    "kind": "pipeline",
    "name": key,
    "platform": {
      "os": "linux",
      "arch": arch,
    },
    "environment": {
      "DOCKER_IMAGE_TOKEN": ver,
    },
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "use_cache": "true",
          "build_args": [
            "ALPINE_TAG=%s" % ver,
          ],
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "run": "abuild -h",
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "registry": {"from_secret": "registry_url"},
          "login": {"from_secret": "registry_login"},
        },
        "when": {
          "branch": branches,
          "event": ["push"],
        },
      },
    ]
  }

def publish(ver, depends, tags=[]):
  return {
    "kind": "pipeline",
    "name": "publish-%s" % ver,
    "depends_on": depends,
    "platform": {
      "os": "linux",
    },
    "environment": {
      "DOCKER_IMAGE_TOKEN": ver,
    },
    "steps": [
      {
        "name": "publish",
        "image": "spritsail/docker-multiarch-publish",
        "pull": "always",
        "settings": {
          "src_registry": {"from_secret": "registry_url"},
          "src_login": {"from_secret": "registry_login"},
          "dest_repo": repo,
          "dest_login": {"from_secret": "docker_login"},
          "tags": [ver] + tags,
        },
        "when": {
          "branch": branches,
          "event": ["push"],
        },
      },
    ]
  }

# vim: ft=python sw=2
