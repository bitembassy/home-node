#!/bin/bash

# Install dependencies
sudo apt install -y autoconf automake build-essential libtool libgmp-dev libsqlite3-dev net-tools zlib1g-dev &&

# Cleanup previous source code files (if any)
rm -rf ~/lightning &&

# Download source
git clone https://github.com/ElementsProject/lightning ~/lightning && cd ~/lightning &&

# Checkout v0.6.3 (latest stable)
git checkout v0.7.0 &&

# Verify signature - should see: Good signature from "Rusty Russell <rusty@rustcorp.com.au>"
git verify-tag v0.7.0 &&

# Build
./configure && make &&

# Install system-wide (requires sudo password)
sudo make install
