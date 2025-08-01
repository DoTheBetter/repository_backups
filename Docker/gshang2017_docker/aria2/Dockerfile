#compiling aria2c
FROM ghcr.io/gshang2017/aria2c:latest AS compilingaria2c


# docker aria2
FROM alpine:3.22

ARG AriaNg_VER=1.3.11
ARG S6_VER=3.2.1.0

ENV UID=1000
ENV GID=1000
ENV UMASK=022
ENV TZ=Asia/Shanghai
ENV ARIA2_RPC_SECRET=
ENV ARIA2_RPC_LISTEN_PORT=6800
ENV ARIA2_LISTEN_PORT=6881
ENV ARIA2_TRACKERS_UPDATE_AUTO=true
ENV ARIA2_TRACKERS_LIST_URL=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt
ENV ARIA2_CONF_LANGUAGE=zh_Hans
ENV ENABLE_ARIANG=true
ENV ARIANG_PORT=8080
ENV ARIANG_RPC_SECRET_AUTO=false
ENV ARIANG_RPC_LISTEN_PORT_AUTO=true
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=compilingaria2c --chmod=755 /usr/local/bin/aria2c /usr/local/bin/aria2c

# install bash darkhttpd tzdata s6 overlay AriaNg aria2 shadow
RUN apk add --no-cache bash curl ca-certificates darkhttpd tzdata shadow c-ares expat gmp gnutls sqlite-libs libstdc++ libssh2 \
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
#create aria2 user
&& useradd -u 1000 -U -d /config -s /bin/false aria2 \
&& usermod -G users aria2 \
# install AriaNg
&& wget -P /tmp https://github.com/mayswind/AriaNg/releases/download/${AriaNg_VER}/AriaNg-${AriaNg_VER}.zip \
&& mkdir -p /usr/local/aria2/AriaNg/js/defaultsjs \
&& unzip -d /usr/local/aria2/AriaNg /tmp/AriaNg-${AriaNg_VER}.zip \
#modify js
#max-connection-per-server
&& sed -i 's/max:16/max:128/g' /usr/local/aria2/AriaNg/js/aria-ng* \
#cp aria-ng* to defaultsjs
&& cp /usr/local/aria2/AriaNg/js/aria-ng* /usr/local/aria2/AriaNg/js/defaultsjs \
#conf trackers
&& curl -so /tmp/trackers_all.txt $ARIA2_TRACKERS_LIST_URL \
&& Newtrackers="bt-tracker=`awk NF /tmp/trackers_all.txt|sed ":a;N;s/\n/,/g;ta"`" \
&& sed -i 's@bt-tracker=@'"$Newtrackers"'@g' /usr/local/aria2/defaults/aria2.conf \
#
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /Downloads /config
EXPOSE 6800 8080 6881 6881/udp
ENTRYPOINT [ "/init" ]
