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

# Download Logseq AppImage
RUN wget https://github.com/logseq/logseq/releases/download/nightly/Logseq-linux-x64-0.10.10-alpha+nightly.20241216.AppImage -O /usr/local/bin/logseq

# Set executable permissions
RUN chmod +x /usr/local/bin/logseq

# Extract and setup AppImage
RUN cd /usr/local/bin && \
    ./logseq --appimage-extract && \
    # Ensure all users have execute permissions
    chmod -R 755 squashfs-root && \
    # Create symbolic link to system path
    ln -s /usr/local/bin/squashfs-root/Logseq /usr/local/bin/Logseq

# Clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY /root /

EXPOSE 3000

VOLUME /config