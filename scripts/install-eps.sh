#!/bin/bash

# Cleanup previous source code files (if any)
rm -rf ~/eps &&

# Download source
git clone https://github.com/chris-belcher/electrum-personal-server.git ~/eps && cd ~/eps &&

# Checkout v$EPS_VERSION (latest stable)
git checkout eps-v$EPS_VERSION &&

# Verify signature - should see 'Good signature from "Chris Belcher <false@email.com>"'
git verify-commit HEAD &&

# Install user-wide
pip3 install --user .
