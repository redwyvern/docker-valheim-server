#!/bin/bash

onShutdown() {
    echo Got SIGTEM, shutting down Valheim server...
    ./vhserver stop
}

trap onShutdown SIGTERM

cd /opt/vhserver

./vhserver start

tail -f --pid $(pgrep valheim_server.) log/console/vhserver-console.log
echo Valheim server process has terminated, exiting container...