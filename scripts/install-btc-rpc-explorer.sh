#!/bin/bash

# Cleanup previous source code files (if any)
rm -rf ~/btc-rpc-explorer &&

# Download source
git clone https://github.com/janoside/btc-rpc-explorer ~/btc-rpc-explorer && cd ~/btc-rpc-explorer &&
git checkout $BTCRPCEXP_VERSION &&

# Verify signature - should see "Good signature from Dan Janosik <dan@47.io>"
git verify-commit HEAD &&

# Install user-wide
npm install -g
