#!/bin/bash

# Iniciar VNC
vncserver :1 -geometry 1280x800 -depth 24

# Esperar a que el DISPLAY esté realmente disponible
echo ">> Esperando a que el servidor gráfico esté listo..."
for i in {1..10}; do
    if xdpyinfo -display :1 >/dev/null 2>&1; then
        echo ">> DISPLAY :1 disponible."
        break
    fi
    echo ">> DISPLAY no disponible aún, reintentando..."
    sleep 1
done

# Iniciar noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

# Ruta del update site local
LOCAL_UPDATE_SITE="/opt/asmeta-update/update"

# Comprobar si ASMETA ya está instalado
ASMETA_INSTALLED=$(ls /opt/eclipse/plugins | grep -c "asmeta")

if [ "$ASMETA_INSTALLED" -eq 0 ]; then
    echo ">> ASMETA no está instalado."

    if [ -d "$LOCAL_UPDATE_SITE" ]; then
        echo ">> Instalando ASMETA desde update site local..."
        DISPLAY=:1 /opt/eclipse/eclipse \
            -nosplash \
            -application org.eclipse.equinox.p2.director \
            -repository "file:$LOCAL_UPDATE_SITE" \
            -installIU asmeta.core.feature.group \
            -installIU asmeta.simulator.feature.group \
            -installIU asmeta.animator.feature.group \
            -installIU asmeta.ctl.feature.group
    else
        echo ">> No se encontró update site local en $LOCAL_UPDATE_SITE"
    fi
else
    echo ">> ASMETA ya está instalado."
fi

# Lanzar Eclipse dentro del entorno gráfico
echo ">> Lanzando Eclipse..."
DISPLAY=:1 /opt/eclipse/eclipse &

# Mantener logs
tail -f /root/.vnc/*.log
