#!/bin/bash

onShutdown() {
    echo Got SIGTEM, shutting down Valheim server...
    ./vhserver stop
    wait $(cat /tmp/vhserver.pid)
}

trap onShutdown SIGTERM

cd /opt/vhserver

echo Valheim server starting...

./vhserver start

echo $(pgrep valheim_server.) >/tmp/vhserver.pid

tail -f --pid $(cat /tmp/vhserver.pid) log/console/vhserver-console.log
echo Valheim server process has terminated, exiting container...