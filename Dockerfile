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
