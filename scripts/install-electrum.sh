#!/bin/bash

# Install dependencies
sudo apt install -y python3-setuptools python3-pyqt5 python3-pip &&

# Create dir for installation files
mkdir -p ~/electrum-installation && cd ~/electrum-installation && rm -rf * &&

# Download source
wget https://download.electrum.org/3.3.4/Electrum-3.3.4.tar.gz &&
# Download signature
wget https://download.electrum.org/3.3.4/Electrum-3.3.4.tar.gz.asc &&

# Add signing key
gpg --recv-keys 6694D8DE7BE8EE5631BED9502BD5824B7F9470E6 &&
# Verify signature - should see "Good signature from Thomas Voegtlin (https://electrum.org) <thomasv@electrum.org>"
gpg --verify Electrum-3.3.4.tar.gz.asc Electrum-3.3.4.tar.gz &&

# Unpack
tar xvf Electrum-3.3.4.tar.gz && cd Electrum-3.3.4 &&

# Install dependencies
pip3 install .[fast] &&
# Install system-wide (requires sudo password)
sudo ./setup.py install
