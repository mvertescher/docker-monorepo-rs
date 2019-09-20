#!/bin/sh
#
# Manual script for deploying the image to Docker Hub

set -ex

DOCKER_ACCOUNT=mvertescher
DOCKER_REPOSITORY=monorepo-rs
IMAGE_TAG=latest

docker login
docker build -t $DOCKER_ACCOUNT/$DOCKER_REPOSITORY:$IMAGE_TAG .
docker push $DOCKER_ACCOUNT/$DOCKER_REPOSITORY:$IMAGE_TAG
