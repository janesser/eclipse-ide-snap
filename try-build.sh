#!/bin/bash
set -e

if [ -n $1 ]; then
    ECLIPSE_PACKAGE=$1
fi

export ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}
export ECLIPSE_CONFINED=${ECLIPSE_CONFINED:=false}

. ./set-eclipse-package.sh

CLEAN=${CLEAN:=false}

if $CLEAN; then
    sudo snap remove --purge $ECLIPSE_PACKAGE
    snapcraft clean
fi

# sudo less /var/snap/lxd/common/lxd/logs/lxd.log
snapcraft pack --debug

AUTORUN=${AUTORUN:=false}
if $AUTORUN; then
    if $ECLIPSE_CONFINED; then
        sudo snap install ./$(echo $ECLIPSE_PACKAGE)_*_$(dpkg --print-architecture).snap --dangerous
    else
        sudo snap install ./$(echo $ECLIPSE_PACKAGE)_*_$(dpkg --print-architecture).snap --dangerous --classic
    fi
    snap run $ECLIPSE_PACKAGE &
fi
