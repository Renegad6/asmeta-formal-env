#!/bin/bash

xhost +local:docker

docker run --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/workspace-eclipse:/workspace \
  eclipse-formal-pro
