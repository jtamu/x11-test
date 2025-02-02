FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# ホストのUIDとGIDを利用してユーザーを作成する
ARG USER_ID
ARG GROUP_ID

# 既存のグループを確認して、なければ作成
RUN if ! getent group $GROUP_ID >/dev/null; then \
    groupadd -g $GROUP_ID hostgroup; \
    fi

# 既存のUIDに対応するユーザーがいない場合、新規ユーザーを作成して、PWなしでsudoを許可
RUN USER_NAME=$(getent passwd $USER_ID | cut -d: -f1) && \
    if [ -z "$USER_NAME" ]; then \
    USER_NAME="hostuser"; \
    useradd -u $USER_ID -g $GROUP_ID -m $USER_NAME; \
    fi && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN sed -i.org -e 's|ports.ubuntu.com|jp.archive.ubuntu.com|g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y \
    x11-apps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y wget pulseaudio socat alsa-base \
    libcanberra-gtk-module libcanberra-gtk3-module \
    fonts-ipafont-gothic fonts-ipafont-mincho fonts-noto-cjk \
    language-pack-ja dbus-x11 && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && echo O | apt-get install -y sudo

USER $USER_NAME

# D-Busの設定と起動を行うコマンドを実行
RUN sudo /etc/init.d/dbus start && \
    export XDG_RUNTIME_DIR=/run/user/$(id -u) && \
    sudo mkdir -p $XDG_RUNTIME_DIR && \
    sudo chmod 700 $XDG_RUNTIME_DIR && \
    sudo chown $(id -un):$(id -gn) $XDG_RUNTIME_DIR && \
    export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus && \
    dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

# google-chrome --no-sandbox --disable-gpu --disable-dev-shm-usage
