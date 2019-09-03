# `monorepo-rs` Dockerfile

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/mvertescher/monorepo-rs)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/mvertescher/monorepo-rs)
![Docker Pulls](https://img.shields.io/docker/pulls/mvertescher/monorepo-rs)

[Dockerhub Repository](https://hub.docker.com/r/mvertescher/monorepo-rs)

> Rust Docker image with some additional tools.

## Deploying

This repository uses Docker Hub [automated builds](https://docs.docker.com/docker-hub/builds/).

- Any pushes to the `master` branch will be automatically deployed to
  hub.docker.com with the `latest` tag.
- Any git tag pushes matching `v` followed by a semver (`v0.1.0` for example)
  will be deployed automatically to hub.docker.com with the same tag.
