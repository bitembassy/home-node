#!/bin/bash

# Cleanup previous source code files (if any)
rm -rf ~/eps &&

# Download source
git clone https://github.com/chris-belcher/electrum-personal-server.git ~/eps && cd ~/eps &&
# Checkout v0.1.6 (latest stable)
git checkout eps-v0.1.6 &&

# Add signing key
gpg --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129 &&
# Verify signature - should see 'Good signature from "Chris Belcher <false@email.com>"'
git verify-commit HEAD &&

# Install user-wide
pip3 install --user .
