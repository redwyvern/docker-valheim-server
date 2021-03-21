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
      vim \
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
    && mkdir /opt/vhserver

RUN chown vhserver.vhserver /opt/vhserver

USER vhserver

# Download the installer
RUN cd /opt/vhserver && \
    wget -O linuxgsm.sh https://linuxgsm.sh && \
    chmod +x linuxgsm.sh && \
    bash linuxgsm.sh vhserver

# Install LGSM Valheim Server
RUN cd /opt/vhserver && ./vhserver auto-install

COPY container-entry.sh /usr/local/bin/
COPY vhserver-default.cfg /opt/vhserver/lgsm/config-lgsm/vhserver/vhserver.cfg

# Fix file and directory ownership & permissions
USER root
RUN chown -R vhserver.vhserver /opt/vhserver && \
    chmod a+x /usr/local/bin/container-entry.sh
USER vhserver

ENTRYPOINT [ "container-entry.sh" ]



