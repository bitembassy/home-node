## Update
```bash
# Fetch the list of available updates, upgrade current
sudo apt-get update &&   
sudo apt-get upgrade &&
sudo apt-get autoremove
```

## Security
```bash
sudo ufw enable &&
sudo ufw allow ssh &&
sudo apt-get install openssh-server &&

# SSH config: disable root login, disable password auth
sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config &&
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config &&
# TODO: set nonstandard SSH port? instructions for setting up keys?

# Secure shared memory
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | sudo tee -a /etc/fstab
```

Edit `/etc/sysctl.conf`, add [this](https://gist.githubusercontent.com/shesek/70a6bf8e8a6f2840ae165bb0bb6da977/raw/d45791f74a50d3f0e89a1819435793b5168ff3b6/sysctl.conf).

## Tor
```bash
sudo apt-get install tor
```

## Bitcoin Core

### Installing
```bash
# Create dir for installation files
mkdir ~/bitcoin-installation && cd ~/bitcoin-installation &&

# Download binaries
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Download signature
wget https://bitcoincore.org/bin/bitcoin-core-0.17.1/SHA256SUMS.asc &&

# Add signing key
gpg --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 &&
# Verify signature - should see "Good signature from Wladimir J. van der Laan (Bitcoin Core binary release signing key) <laanwj@gmail.com>"
gpg --verify SHA256SUMS.asc &&
# Verify the binary matches the signed hash in SHA256SUMS.asc - should see "bitcoin-0.17.1-x86_64-linux-gnu.tar.gz: OK"
grep bitcoin-0.17.1-x86_64-linux-gnu.tar.gz SHA256SUMS.asc | sha256sum -c - &&

# Unpack binaries
tar xvf bitcoin-0.17.1-x86_64-linux-gnu.tar.gz &&
# Install binaries system-wide (requires password)
sudo cp bitcoin-0.17.1/bin/* /usr/bin
```

### Configuring
Create and edit `bitcoin.conf`

```bash
mkdir ~/.bitcoin &&
gedit ~/.bitcoin/bitcoin.conf
```
Add the following and save:
```bash
server=1
proxy=127.0.0.1:9050

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

### Adding a startup service

TODO

## btc-rpc-explorer

### Installing
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
# Copy the bitcoind rpc user/pass from ~/.bitcoin/bitcoin.conf to ./app/credentials.js
sed -i -r 's/username:"[^"]+"/username:"'`grep ^rpcuser= ~/.bitcoin/bitcoin.conf | cut -d= -f2`'"/' app/credentials.js &&
sed -i -r 's/password:"[^"]+"/password:"'`grep ^rpcpassword= ~/.bitcoin/bitcoin.conf | cut -d= -f2`'"/' app/credentials.js
```

### Running
```bash
npm start
```

Then open http://localhost:3002/.

### Setup hidden service

TODO

### Adding a startup service

TODO

## Electrum Wallet

### Installing

```bash
# Install dependencies
sudo apt-get install python3-setuptools python3-pyqt5 python3-pip &&

# Create dir for installation files
mkdir ~/electrum-installation && cd ~/electrum-installation &&

# Download source
wget https://download.electrum.org/3.3.2/Electrum-3.3.2.tar.gz &&
# Download signature
wget https://download.electrum.org/3.3.2/Electrum-3.3.2.tar.gz.asc &&

# Add signing key
gpg --recv-keys 6694D8DE7BE8EE5631BED9502BD5824B7F9470E6 &&
# Verify signature - should see "Good signature from Thomas Voegtlin (https://electrum.org) <thomasv@electrum.org>"
gpg --verify Electrum-3.3.2.tar.gz.asc Electrum-3.3.2.tar.gz &&

# Unpack
tar xvf Electrum-3.3.2.tar.gz && cd Electrum-3.3.2 &&

# Install system-wide (requires sudo password)
sudo python3 -m pip install .[fast] &&
sudo python3 setup.py install
```

### Configuring
```
# Connect to local EPS server only
electrum setconfig server 127.0.0.1:50002:s &&
electrum setconfig oneserver true
```

### Running
Electrum can now be opened from the launcher or using the command line with `electrum`.

> Note: You may now open Electrum and configure a wallet, but it won't connect to a server until EPS is configured (next step) and `bitcoind` is synced.

## Electrum Personal Server

### Installing
```
# Download source
git clone https://github.com/chris-belcher/electrum-personal-server.git ~/eps && cd ~/eps &&
# Checkout v0.1.6 (latest stable)
git checkout eps-v0.1.6 &&

# Add signing key
gpg --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129 &&
# Verify signature - should see 'Good signature from "Chris Belcher <false@email.com>"'
git verify-commit HEAD &&

# Install system-wide (requires sudo password)
sudo pip3 install .
```

### Configuring

Copy the sample configuration file as `eps.cnf` and edit it:
```
cp ~/eps/config.cfg_sample ~/eps.cfg &&
gedit ~/eps.cfg
```

Find your Master Public Key in electrum wallet (Wallet > Information) and add it to `eps.cfg` under `[master-public-keys]` as a new line with `{name}={xpubkey}`. `name` can be anything. (The sample config already has this line, uncomment and replace sample xpubkey).

Find your `rpcuser` and `rpcpassword` in `~/bitcoin/bitcoin.conf` and add them to `eps.cfg` under `[bitcoin-rpc]`as a new line with `rpc_user=[user from bitcoin.conf]` and `rpc_password=[password from bitcoin.conf]`(uncomment the two lines).

Save `eps.cfg`

### Running
```bash
electrum-personal-server ~/eps.cfg
```
> Note: Electrum Wallet will only connect to Electrum Personal Server once bitcoind is synced.

### Adding as a startup service

TODO

### Setup hidden service

TODO

## c-lightning

### Installing
```bash
# Install dependencies
sudo apt install autoconf automake build-essential libtool libgmp-dev libsqlite3-dev net-tools zlib1g-dev &&

# Download source
git clone https://github.com/ElementsProject/lightning ~/lightning && cd ~/lightning &&
# Checkout v0.6.3 (latest stable)
git checkout v0.6.3 &&

# Add signing key
gpg --recv-keys 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1 &&
# Verify signature - should see XXX
git verify-tag v0.6.3 &&

# Build
./configure && make &&

# Install system-wide (requires sudo password)
sudo make install
```

### Adding as a startup service

TODO

## Spark Wallet

### Installing
```bash
# Install dependencies
sudo apt-get install nodejs npm &&

# Create dir for installation files
mkdir ~/spark-installation && cd ~/spark-installation &&

# Download npm package
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.2/spark-wallet-0.2.2-npm.tgz &&
# Download signature
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.2/SHA256SUMS.asc &&

# Add signing key
gpg --keyserver hkp://keyserver.ubuntu.com/ --recv-keys FCF19B67866562F08A43AAD681F6104CD0F150FC &&
# Verify signature - should show "Good signature from Nadav Ivgi <nadav@shesek.info>"
gpg --verify SHA256SUMS.asc &&
# Verify the downloaded binary matches the signed hash in SHA256SUMS.asc
grep spark-wallet-0.2.2-npm.tgz SHA256SUMS.asc | sha256sum -c - &&

# Install system-wide (requires sudo password)
sudo npm install -g spark-wallet-0.2.2-npm.tgz
```

### Configuring

Create `~/.spark-wallet/config`, set your username/password:

```
# this grants access to the funds in your lightning wallet, pick a strong password!
login={username}:{password}
```

Or generate random credentials with:

```bash
echo "login=`head -c 5 /dev/urandom | base64 | tr -d '+/='`:`head -c 30 /dev/urandom | base64 | tr -d '+/='`" | tee -a ~/.spark-wallet/config
```

### Running
```bash
spark-wallet
```

Then open http://localhost:9737/.

### Adding as a startup service

TODO

### Setup hidden service

TODO