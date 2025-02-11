FROM ubuntu:latest
LABEL org.opencontainers.image.authors="abcfy2@163.com"

ARG ARCH=arm-unknown-linux-musleabi

ENV CROSS_HOST="${ARCH}"
ENV CROSS_ROOT="/cross_root"
ENV PATH="${CROSS_ROOT}/bin:${PATH}"
ENV CROSS_PREFIX="${CROSS_ROOT}/${CROSS_HOST}"

RUN export DEBIAN_FRONTEND=noninteractive && \
  mkdir -p "${CROSS_ROOT}" && \
  apt update && \
  apt install -y wget xz-utils && \
  wget -cT10 -P /tmp "https://github.com/musl-cross/musl-cross/releases/latest/download/${ARCH}.tar.xz" && \
  SHA256SUM="$(wget -qO- "https://github.com/musl-cross/musl-cross/releases/latest/download/${ARCH}.tar.xz.sha256")" && \
  cd /tmp && \
  echo "${SHA256SUM} ${ARCH}.tar.xz" | sha256sum -c && \
  tar -Jxf "/tmp/${ARCH}.tar.xz" --transform='s|^\./||S' --strip-components=1 -C "${CROSS_ROOT}" && \
  rm -f "/tmp/${ARCH}.tar.xz" "${CROSS_ROOT}/build.log.bz2" && \
  echo "${SHA256SUM}" > /SHA256SUM.txt && \
  apt purge -y --auto-remove wget xz-utils ca-certificates && \
  rm -fr /var/lib/apt/lists/*
