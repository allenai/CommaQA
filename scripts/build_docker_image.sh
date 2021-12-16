#!/usr/bin/env bash

set -e

IMAGE_NAME=commaqa
DOCKERFILE_NAME=Dockerfile

# Image name
GIT_HASH=`git log --format="%h" -n 1`
IMAGE=$IMAGE_NAME_$USER-$GIT_HASH

docker build -f $DOCKERFILE_NAME -t $IMAGE .

echo -e "\033[0;32m Built image $IMAGE. If using Beaker, now run: \033[0m"
echo -e "\033[0;35m beaker image create --name=$IMAGE --description \"CommaQA Repo; Git Hash: $GIT_HASH\" $IMAGE \033[0m"
