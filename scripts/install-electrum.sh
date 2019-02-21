#!/bin/bash

# Install dependencies
sudo apt install -y python3-setuptools python3-pyqt5 python3-pip &&

# Create dir for installation files
mkdir -p ~/electrum-installation && cd ~/electrum-installation && rm -rf * &&

# Download source
wget https://download.electrum.org/$ELECTRUM_VERSION/Electrum-$ELECTRUM_VERSION.tar.gz &&

# Download signature
wget https://download.electrum.org/$ELECTRUM_VERSION/Electrum-$ELECTRUM_VERSION.tar.gz.asc &&

# Verify signature - should see "Good signature from Thomas Voegtlin (https://electrum.org) <thomasv@electrum.org>"
gpg --verify Electrum-$ELECTRUM_VERSION.tar.gz.asc Electrum-$ELECTRUM_VERSION.tar.gz &&

# Unpack
tar xvf Electrum-$ELECTRUM_VERSION.tar.gz && cd Electrum-$ELECTRUM_VERSION &&

# Install dependencies
pip3 install .[fast] &&

# Install system-wide (requires sudo password)
sudo ./setup.py install
