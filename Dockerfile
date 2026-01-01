FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------
# 1. Dependencias del sistema
# -----------------------------
RUN apt update && apt install -y \
    wget \
    curl \
    git \
    maven \
    openjdk-17-jdk \
    build-essential \
    graphviz \
    python3 \
    python3-pip \
    unzip \
    bison \
    libgtk-3-0 \
    libasound2 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libglib2.0-0 \
    libnss3 \
    libxss1 \
    libgdk-pixbuf2.0-0 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxrandr2 \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    && apt clean

# -----------------------------
# 2. Instalar Z3
# -----------------------------
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.12.2/z3-4.12.2-x64-glibc-2.31.zip \
    && unzip z3-4.12.2-x64-glibc-2.31.zip -d /opt/z3 \
    && rm z3-4.12.2-x64-glibc-2.31.zip

ENV PATH="/opt/z3/bin:$PATH"

# -----------------------------
# 3. Instalar NuSMV
# -----------------------------
RUN wget https://nusmv.fbk.eu/distrib/NuSMV-2.6.0-linux64.tar.gz \
    && tar -xzf NuSMV-2.6.0-linux64.tar.gz -C /opt \
    && rm NuSMV-2.6.0-linux64.tar.gz

ENV PATH="/opt/NuSMV-2.6.0-Linux/bin:$PATH"

# -----------------------------
# 4. Instalar Spin (6.5.2)
# -----------------------------
RUN wget https://github.com/nimble-code/Spin/archive/refs/tags/version-6.5.2.tar.gz \
    && tar -xzf version-6.5.2.tar.gz \
    && cd Spin-version-6.5.2/Src && make \
    && cp spin /usr/local/bin \
    && cd / && rm -rf Spin-version-6.5.2 version-6.5.2.tar.gz

# -----------------------------
# 5. Instalar Eclipse 
# -----------------------------
WORKDIR /opt

RUN rm -rf /opt/eclipse \
  && wget -O eclipse.tar.gz \
     "https://ftp.fau.de/eclipse/technology/epp/downloads/release/2025-12/R/eclipse-modeling-2025-12-R-linux-gtk-x86_64.tar.gz" \
  && tar -xzf eclipse.tar.gz \
  && rm eclipse.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$PATH:/opt/eclipse"

# -----------------------------
# 6. Workspace por defecto
# -----------------------------
RUN mkdir -p /workspace
VOLUME /workspace

# -----------------------------
# 7. Configurar VNC
# -----------------------------
RUN mkdir -p /root/.vnc && \
    echo "1234" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# -----------------------------
# 8. Script de arranque VNC + noVNC + ASMETA auto-install
# -----------------------------
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

EXPOSE 5901 6080

# -----------------------------
# 9. Comando por defecto
# -----------------------------
CMD ["/start-vnc.sh"]
