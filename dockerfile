FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ENV TITLE=Logseq

ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的包
RUN apt-get update && \
    apt-get install -y wget python3-xdg

RUN apt-get install -y \
apt-utils \
ca-certificates \
fonts-noto-cjk \
fonts-noto-cjk-extra 

RUN apt-get install -y \
# 音频相关
libasound2t64 \
# GTK 相关
libatk1.0-0 \
libatk-bridge2.0-0 \
libcups2 \
libdrm2 \
libgtk-3-0 \
libgbm1 \
# X11 相关
libxcomposite1 \
libxdamage1 \
libxfixes3 \
libxrandr2 \
libxshmfence1 \
libx11-xcb1 \
libxcursor1 \
libxi6 \
libxtst6

# 下载 Logseq AppImage
RUN wget https://github.com/logseq/logseq/releases/download/nightly/Logseq-linux-x64-0.10.10-alpha+nightly.20241105.AppImage -O /usr/local/bin/logseq

# 设置可执行权限
RUN chmod +x /usr/local/bin/logseq

# 解压和设置 AppImage
RUN cd /usr/local/bin && \
    ./logseq --appimage-extract && \
    # 确保所有用户都有执行权限
    chmod -R 755 squashfs-root && \
    # 创建符号链接到系统路径
    ln -s /usr/local/bin/squashfs-root/Logseq /usr/local/bin/Logseq

# 清理缓存
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY /root /

EXPOSE 3000

VOLUME /config