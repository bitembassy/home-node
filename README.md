## Tor
```bash
apt-get install tor
```

## Bitcoin Core

### Installing
```bash
# Create temp dir for installation
mkdir ~/bitcoin-installation && cd ~/bitcoin-installation &&

# Download binaries
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Download signatures
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/SHA256SUMS.asc &&

# Add signing key
gpg --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 &&
# Verify signatures - should see XXXXXX
gpg --verify SHA256SUMS.asc &&
# Verify the downloaded binary matches the signed hash in SHA256SUMS.asc
grep bitcoin-0.17.1-x86_64-linux-gnu.tar.gz SHA256SUMS.asc | sha256sum -c - &&

# Unpack binaries
tar xvf bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Install binaries system-wide
sudo cp bitcoin-0.17.1/bin/* /usr/bin &&

# Cleanup
rm -rf ~/bitcoin-installation
```

### Configuring

Edit `~/.bitcoin/bitcoin.conf`, add:

```bash
server=1
proxy=127.0.0.1:9050
disablewallet=1

# Check total memory with `free -m`, can be removed after initial sync
dbcache=???

# Optional (takes more space, needed for btc-rpc-explorer)
txindex=1
```

Generate random username/password for rpc access:

```bash
echo "
rpcuser=`head -c 5 /dev/urandom | base64 | tr -d '+/='`
rpcpassword=`head -c 30 /dev/urandom | base64 | tr -d '+/='`
" | tee -a ~/.bitcoin/bitcoin.conf
```

### Running
```bash
bitcoind
```

### Adding as a service

TODO

## btc-rpc-explorer

### Install
```bash
# Install dependencies
sudo apt install nodejs npm git &&
# Download source
git clone https://github.com/janoside/btc-rpc-explorer ~/btc-rpc-explorer &&
cd ~/btc-rpc-explorer &&
# Build source
npm install && npm run build
```

### Configuring
```bash
# Copy bitcoind rpc username/password from ~/.bitcoin/bitcoin.conf to ./app/credentials.js
sed -i -r 's/username:"[^"]+"/username:"'`grep ^rpcuser= ~/.bitcoin/bitcoin.conf | cut -d= -f2`'"/' app/credentials.js
sed -i -r 's/password:"[^"]+"/password:"'`grep ^rpcpassword= ~/.bitcoin/bitcoin.conf | cut -d= -f2`'""/' app/credentials.js
```

### Running
```bash
npm start
```

Then open: http://localhost:3002/
