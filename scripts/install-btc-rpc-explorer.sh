#!/bin/bash

# Cleanup previous source code files (if any)
rm -rf ~/btc-rpc-explorer &&

# Download source
git clone https://github.com/janoside/btc-rpc-explorer ~/btc-rpc-explorer && cd ~/btc-rpc-explorer &&
git checkout 1ca6f54b93a56d942a90f3e0072265c9df3b9e6c &&

# Add signing key
gpg --recv-keys F579929B39B119CC7B0BB71FB326ACF51F317B69 &&
# Verify signature - should see "Good signature from Dan Janosik <dan@47.io>"
git verify-commit HEAD &&

# Install user-wide
npm install -g
