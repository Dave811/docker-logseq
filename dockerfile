FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ENV TITLE=Logseq

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget python3-xdg

RUN apt-get install -y \
    apt-utils \
    ca-certificates \
    fonts-noto-cjk \
    fonts-noto-cjk-extra 

RUN apt-get install -y \
    # Audio related
    libasound2t64 \
    # GTK related
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    # X11 related
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxshmfence1 \
    libx11-xcb1 \
    libxcursor1 \
    libxi6 \
    libxtst6

# Download and setup Logseq based on architecture
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
    # Download x86_64 AppImage
    wget https://github.com/logseq/logseq/releases/download/0.10.12/Logseq-linux-x64-0.10.12.AppImage -O /usr/local/bin/logseq && \
    chmod +x /usr/local/bin/logseq && \
    cd /usr/local/bin && \
    ./logseq --appimage-extract && \
    chmod -R 755 squashfs-root && \
    ln -s /usr/local/bin/squashfs-root/Logseq /usr/local/bin/Logseq; \
    elif [ "$ARCH" = "aarch64" ]; then \
    # Download ARM64 ZIP package
    wget https://github.com/logseq/logseq/releases/download/0.10.12/Logseq-linux-arm64-0.10.12.zip -O /tmp/logseq.zip && \
    apt-get install -y unzip && \
    unzip /tmp/logseq.zip -d /usr/local/bin/ && \
    chmod -R 755 /usr/local/bin/Logseq-linux-arm64 && \
    ln -s /usr/local/bin/Logseq-linux-arm64/Logseq /usr/local/bin/Logseq && \
    rm /tmp/logseq.zip; \
    else \
    echo "Unsupported architecture: $ARCH" && exit 1; \
    fi

# Clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY /root /

EXPOSE 3000

VOLUME /config