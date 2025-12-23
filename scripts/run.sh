#!/bin/bash

# Usage:
#   ./run.sh                → ephemeral mode (temporary container)
#   ./run.sh --persistent   → persistent mode (keeps ASMETA installed)
#   ./run.sh --clean        → remove stopped containers

MODE=$1
IMAGE="ghcr.io/renegad6/eclipse-formal-pro:latest"

# Allow graphical access
xhost +local:docker > /dev/null

# --- Automatic image update ---
echo ">> Checking for a newer version of the image..."
docker pull $IMAGE >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ">> Image updated from GHCR (if changes were available)."
else
    echo ">> Could not update the image (offline or image not found)."
    echo ">> Using the local image instead."
fi

case "$MODE" in

    --persistent)
        echo ">> Persistent mode enabled."
        echo ">> The container 'asmeta-env' will keep ASMETA and internal configuration."

        # Create the container if it does not exist
        if ! docker ps -a --format '{{.Names}}' | grep -q '^asmeta-env$'; then
            echo ">> Creating persistent container for the first time..."
            docker create \
                -e DISPLAY=$DISPLAY \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v ~/workspace-eclipse:/workspace \
                --name asmeta-env \
                $IMAGE
        fi

        # Start the persistent container
        docker start -a asmeta-env
        ;;

    --clean)
        echo ">> Cleaning stopped containers..."
        docker container prune -f
        echo ">> Cleanup completed."
        ;;

    *)
        echo ">> Running in EPHEMERAL mode (temporary container)."
        echo ">> To keep ASMETA installed inside the container, use:"
        echo "       ./run.sh --persistent"
        echo ">> To clean stopped containers, use:"
        echo "       ./run.sh --clean"
        echo ""

        docker run --rm \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v ~/workspace-eclipse:/workspace \
            $IMAGE
        ;;
esac
