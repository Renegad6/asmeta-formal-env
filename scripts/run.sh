#!/bin/bash

# Usage:
#   ./run.sh                → ephemeral mode (temporary container)
#   ./run.sh --persistent   → persistent mode (keeps workspace)
#   ./run.sh --clean        → remove stopped containers

MODE=$1
IMAGE="ghcr.io/renegad6/eclipse-formal-pro:latest"
CONTAINER_NAME="asmeta-env"

echo ">> Checking for a newer version of the image..."
 #docker pull $IMAGE >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ">> Image updated from GHCR (if changes were available)."
else
    echo ">> Could not update the image (offline or image not found)."
    echo ">> Using the local image instead."
fi

case "$MODE" in

    --persistent)
        echo ">> Persistent mode enabled."
        echo ">> Container: $CONTAINER_NAME"

        # Create the container if it does not exist
        if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
            echo ">> Creating persistent container for the first time..."
docker create \
    -p 6080:6080 \
    -p 5901:5901 \
    -v ~/workspace-eclipse:/workspace \
    -v /workspaces/asmeta-formal-env/asmeta-update:/opt/asmeta-update \
    --name $CONTAINER_NAME \
    --entrypoint /start-vnc.sh \
    $IMAGE

        fi

        # Start the persistent container
        docker start -a $CONTAINER_NAME
        ;;

    --clean)
        echo ">> Cleaning stopped containers..."
        docker container prune -f
        echo ">> Cleanup completed."
        ;;

    *)
        echo ">> Running in EPHEMERAL mode (temporary container)."
        echo ">> To keep ASMETA installed and workspace persistent, use:"
        echo "       ./run.sh --persistent"
        echo ">> To clean stopped containers, use:"
        echo "       ./run.sh --clean"
        echo ""

        docker run --rm \
            -p 6080:6080 \
            -p 5901:5901 \
            -v /workspaces/asmeta-formal-env/asmeta-update:/opt/asmeta-update \
            $IMAGE
        ;;
esac
