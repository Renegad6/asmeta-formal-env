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
# 4. Instalar Spin
# -----------------------------
RUN wget http://spinroot.com/spin/Src/spin647.tar.gz \
    && tar -xzf spin647.tar.gz \
    && cd Spin/Src6.4.7 && make \
    && cp spin /usr/local/bin \
    && cd / && rm -r Spin spin647.tar.gz

# -----------------------------
# 5. Instalar Eclipse
# -----------------------------
WORKDIR /opt

RUN wget https://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/2024-12/R/eclipse-java-2024-12-R-linux-gtk-x86_64.tar.gz \
    && tar -xzf eclipse-java-2024-12-R-linux-gtk-x86_64.tar.gz \
    && rm eclipse-java-2024-12-R-linux-gtk-x86_64.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$PATH:/opt/eclipse"
ENV DISPLAY=:0

# -----------------------------
# 6. Instalar ASMETA automáticamente
# -----------------------------
RUN /opt/eclipse/eclipse \
    -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository https://asmeta.github.io/update/ \
    -installIU asmeta.core.feature.group \
    -installIU asmeta.simulator.feature.group \
    -installIU asmeta.animator.feature.group \
    -installIU asmeta.ctl.feature.group

# -----------------------------
# 7. Workspace por defecto
# -----------------------------
RUN mkdir -p /workspace
VOLUME /workspace

# -----------------------------
# 8. Comando por defecto
# -----------------------------
CMD ["/opt/eclipse/eclipse"]
