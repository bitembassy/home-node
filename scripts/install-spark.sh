#!/bin/bash

# Create dir for installation files
mkdir -p ~/spark-installation && cd ~/spark-installation && rm -rf * &&

# Download npm package
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.4/spark-wallet-0.2.4-npm.tgz &&
# Download signature
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.4/SHA256SUMS.asc &&

# Add signing key
gpg --recv-keys FCF19B67866562F08A43AAD681F6104CD0F150FC &&
# Verify signature - should show "Good signature from Nadav Ivgi <nadav@shesek.info>"
gpg --verify SHA256SUMS.asc &&
# Verify the downloaded binary matches the signed hash in SHA256SUMS.asc
grep spark-wallet-0.2.4-npm.tgz SHA256SUMS.asc | sha256sum -c - &&

# Install user-wide
npm install -g spark-wallet-0.2.4-npm.tgz
