#!/bin/sh

set -ex

DOCKER_REPOSITORY=mvertescher/monorepo-rs
DOCKER_TAG=latest

docker login
docker build -t $DOCKER_REPOSITORY:$DOCKER_TAG docker
docker push $DOCKER_REPOSITORY:$DOCKER_TAG
