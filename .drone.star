def main(ctx):
  return [
    step("3.8"),
    step("3.9"),
    step("3.10"),
    step("3.11",["latest"]),
    step("edge"),
  ]

def step(alpinever,tags=[]):
  return {
    "kind": "pipeline",
    "name": "build-%s" % alpinever,
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "repo": "abuild-dev-%s" % alpinever,
          "use_cache": "true",
          "build_args": [
            "ALPINE_TAG=%s" % alpinever,
          ],
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "repo": "abuild-dev-%s" % alpinever,
          "run": "abuild -h",
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "from": "abuild-dev-%s" % alpinever,
          "repo": "spritsail/abuild",
          "tags": [alpinever] + tags,
          "username": {
            "from_secret": "docker_username",
          },
          "password": {
            "from_secret": "docker_password",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }
