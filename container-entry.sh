#!/bin/bash

onShutdown() {
    echo Got SIGTEM, shutting down Valheim server...
    ./vhserver stop
    wait $(cat /var/run/vhserver.pid)
}

trap onShutdown SIGTERM

cd /opt/vhserver

echo Valheim server starting...

./vhserver start

echo $(pgrep valheim_server.) >/var/run/vhserver.pid

tail -f --pid $(cat /var/run/vhserver.pid) log/console/vhserver-console.log
echo Valheim server process has terminated, exiting container...