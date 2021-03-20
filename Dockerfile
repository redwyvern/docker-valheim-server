FROM docker.artifactory.weedon.org.au/redwyvern/ubuntu-base:focal
LABEL version="1.0"

RUN dpkg --add-architecture i386 && \
    apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends debconf-utils && \
    echo steamcmd        steam/license   note | debconf-set-selections && \
    echo steamcmd        steam/question  select  I AGREE | debconf-set-selections && \
    echo steamcmd        steam/purge     note | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      binutils \
      iproute2 \
      cpio \
      curl \
      wget \
      file \
      tar \
      bzip2 \
      gzip \
      unzip \
      bsdmainutils \
      python \
      util-linux \
      ca-certificates \
      binutils \
      bc \
      jq \
      tmux \
      netcat \
      lib32gcc1 \
      lib32stdc++6 \
      libsdl2-2.0-0:i386 \
      steamcmd && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN adduser --disabled-password --gecos "" vhserver \
    && mkdir /opt/vhserver \
    && chown vhserver.vhserver /opt/vhserver

USER vhserver

RUN cd /opt/vhserver && \
    wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh vhserver

RUN cd /opt/vhserver && \
    ./vhserver auto-install

COPY vhserver-default.cfg /opt/vhserver/lgsm/config-lgsm/vhserver/vhserver.cfg

CMD while true; sleep 1; done

USER root

#CMD tail -f --pid $(pgrep valheim_server.) log/console/vhserver-console.log

