#!/bin/bash

# Install dependencies
sudo apt install -y autoconf automake build-essential libtool libgmp-dev libsqlite3-dev net-tools zlib1g-dev &&

# Cleanup previous source code files (if any)
rm -rf ~/lightning &&

# Download source
git clone https://github.com/ElementsProject/lightning ~/lightning && cd ~/lightning &&

# Checkout v$CLIGHTNING_VERSION (latest stable)
git checkout v$CLIGHTNING_VERSION &&

# Verify signature - should see: Good signature from "Rusty Russell <rusty@rustcorp.com.au>"
git verify-tag v$CLIGHTNING_VERSION &&

# Build
./configure && make &&

# Install system-wide (requires sudo password)
sudo make install
