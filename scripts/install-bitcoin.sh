#!/bin/bash

# Create dir for installation files
mkdir -p ~/bitcoin-installation && cd ~/bitcoin-installation && rm -rf * &&

# Download binaries
wget https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz &&

# Download signature
wget https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc &&

# Verify signature - should see "Good signature from Wladimir J. van der Laan (Bitcoin Core binary release signing key) <laanwj@gmail.com>"
gpg --verify SHA256SUMS.asc &&

# Verify the binary matches the signed hash in SHA256SUMS.asc - should see "bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz: OK"
grep bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz SHA256SUMS.asc | sha256sum -c - &&

# Unpack binaries
tar xvf bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz &&

# Install binaries system-wide (requires password)
sudo cp bitcoin-$BITCOIN_VERSION/bin/* /usr/bin
