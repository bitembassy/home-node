### Installing Bitcoin Core
```bash
# Create envirnoment
mkdir ~/bitcoin-installation && cd ~/bitcoin-installation &&

# Download binaries
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Download signatures
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/SHA256SUMS.asc &&

# Add signing key
gpg --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 &&
# Verify signatures - should see XXXXXX
gpg --verify SHA256SUMS.asc &&
# Verify the download shasum matches the signed shasum
sha256sum -c --ignore-missing SHA256SUMS.asc &&

# Unpack binaries
tar xvf bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Install binaries system-wide
sudo cp bitcoin-0.17.1/bin/* /usr/bin &&

# Cleanup
rm -rf ~/bitcoin-installation
```