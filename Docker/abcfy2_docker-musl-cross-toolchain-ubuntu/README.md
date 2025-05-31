# musl-cross toolchain for Ubuntu based docker image

![CI](https://github.com/abcfy2/docker-musl-cross-toolchain-ubuntu/actions/workflows/ci.yml/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/abcfy2/musl-cross-toolchain-ubuntu)](https://hub.docker.com/r/abcfy2/musl-cross-toolchain-ubuntu)

This image can be also found in [GHCR](https://github.com/abcfy2/docker-musl-cross-toolchain-ubuntu/pkgs/container/musl-cross-toolchain-ubuntu) and [Quay.io](https://quay.io/repository/abcfy2/musl-cross-toolchain-ubuntu).

`Dockerfile` can be found at [abcfy2/docker-musl-cross-toolchain-ubuntu#Dockerfile](https://github.com/abcfy2/docker-musl-cross-toolchain-ubuntu/blob/main/Dockerfile).

This is the musl based toolchain from [musl-cross](https://github.com/cross-tools/musl-cross/).

This is useful for some building environments which require a glibc based library.

Cross toolchain installed in `/cross_root`. And `/cross_root/bin` has been already appended to `PATH`, so you can use cross compiler like `arm-linux-unknown-musleabi-gcc -v` directly.

An useful example can be found at [abcfy2/aria2-static-build](https://github.com/abcfy2/aria2-static-build/blob/main/build.sh)
