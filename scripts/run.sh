#!/bin/bash

# Uso:
#   ./run.sh                → modo efímero (contenedor temporal)
#   ./run.sh --persistent   → modo persistente (mantiene ASMETA instalado)
#   ./run.sh --clean        → limpia contenedores parados

MODE=$1

# Permitir acceso gráfico
xhost +local:docker > /dev/null

case "$MODE" in

    --persistent)
        echo ">> Modo persistente activado."
        echo ">> El contenedor 'asmeta-env' conservará ASMETA y cualquier configuración interna."

        # Crear el contenedor si no existe
        if ! docker ps -a --format '{{.Names}}' | grep -q '^asmeta-env$'; then
            echo ">> Creando contenedor persistente por primera vez..."
            docker create \
                -e DISPLAY=$DISPLAY \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v ~/workspace-eclipse:/workspace \
                --name asmeta-env \
                eclipse-formal-pro
        fi

        # Arrancar el contenedor persistente
        docker start -a asmeta-env
        ;;

    --clean)
        echo ">> Limpiando contenedores parados..."
        docker container prune -f
        echo ">> Limpieza completada."
        ;;

    *)
        echo ">> Ejecutando en modo EFÍMERO (contenedor temporal)."
        echo ">> Si quieres conservar ASMETA instalado dentro del contenedor, usa:"
        echo "       ./run.sh --persistent"
        echo ">> Para limpiar contenedores parados, usa:"
        echo "       ./run.sh --clean"
        echo ""

        docker run --rm \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v ~/workspace-eclipse:/workspace \
            eclipse-formal-pro
        ;;
esac
