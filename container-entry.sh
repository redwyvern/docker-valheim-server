#!/bin/bash

onShutdown() {
    echo Got SIGTERM, shutting down Valheim server...
    ./vhserver stop

    while [ -e /proc/$(cat /tmp/vhserver.pid) ]
    do
      sleep .5
    done
    echo Valheim server process has terminated, exiting container...
    exit
}

trap onShutdown SIGTERM

cd /opt/vhserver

echo Valheim server starting...

./vhserver start

echo $(pgrep valheim_server.) >/tmp/vhserver.pid

tail -f --pid $(cat /tmp/vhserver.pid) log/console/vhserver-console.log & wait
