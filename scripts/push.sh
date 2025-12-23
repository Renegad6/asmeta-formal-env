#!/bin/bash

IMAGE="eclipse-formal-pro"
USER="TU_USUARIO"

docker tag $IMAGE ghcr.io/$USER/$IMAGE:latest
docker push ghcr.io/$USER/$IMAGE:latest
