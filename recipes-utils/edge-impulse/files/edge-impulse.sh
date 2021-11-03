#!/bin/sh

# exit on first error
set -e

# install edge-impulse-linux if it's not already
if ! which edge-impulse-linux &> /dev/null ; then
    # globally install edge-impulse, if not already
    echo "Installing edge-impulse-linux..."
    npm config set user root
    sudo npm install edge-impulse-linux -g --unsafe-perm
fi

# lauch edge impulse
echo "Launching edge-impulse-linux..."
edge-impulse-linux
