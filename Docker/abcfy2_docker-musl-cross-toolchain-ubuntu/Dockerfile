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
  case "${ARCH}" in \
    *w64-mingw32*) \
      REPO_URL="https://github.com/cross-tools/mingw-cross" \
      ;; \
    *) \
      REPO_URL="https://github.com/cross-tools/musl-cross" \
      ;; \
  esac && \
  wget -cT10 -P /tmp "${REPO_URL}/releases/latest/download/${ARCH}.tar.xz" && \
  SHA256SUM="$(wget -qO- "${REPO_URL}/releases/latest/download/${ARCH}.tar.xz.sha256")" && \
  cd /tmp && \
  echo "${SHA256SUM} ${ARCH}.tar.xz" | sha256sum -c && \
  tar -Jxf "/tmp/${ARCH}.tar.xz" --transform='s|^\./||S' --strip-components=1 -C "${CROSS_ROOT}" && \
  rm -f "/tmp/${ARCH}.tar.xz" "${CROSS_ROOT}/build.log.bz2" && \
  echo "${SHA256SUM}" > /SHA256SUM.txt && \
  apt purge -y --auto-remove wget xz-utils ca-certificates && \
  rm -fr /var/lib/apt/lists/*
