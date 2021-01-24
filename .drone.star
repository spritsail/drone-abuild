def main(ctx):
  return [
    step("3.10"),
    step("3.11"),
    step("3.12"),
    step("3.13",["latest"]),
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
          "run": "abuild -h",
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "repo": "spritsail/abuild",
          "tags": [alpinever] + tags,
          "login": {
            "from_secret": "docker_login",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }
