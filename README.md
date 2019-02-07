## Updates
```bash
# Fetch the list of available updates, upgrade current
sudo apt-get update &&   
sudo apt-get upgrade -y &&
sudo apt-get autoremove -y
```

## Security
```bash
# Setup firewall
sudo ufw enable &&
sudo ufw allow from 127.0.0.1 to any &&

# Secure shared memory
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | sudo tee -a /etc/fstab
```

Edit `/etc/sysctl.conf`, add [this](https://github.com/bitembassy/home-node/raw/master/misc/sysctl.conf).

## Environment

```bash
sudo apt-get install -y nodejs npm git &&

# Install global npm packages to ~/.npm-global (prevents permission headaches, see https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)
mkdir ~/.npm-global && npm config set prefix '~/.npm-global' &&
echo 'export PATH=~/.npm-global/bin:$PATH' | tee -a ~/.profile && source ~/.profile
```

## Tor
```bash
sudo apt-get install -y tor torbrowser-launcher &&

# Fix for https://bugs.python.org/issue20087, necessary for torbrowser-launcher < 0.3
sudo update-locale LANG=en_US.UTF-8
```

The Tor browser can be accessed from the launcher.

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
sudo cp bitcoin-0.17.1/bin/* /usr/bin &&

# Cleanup installation files
rm -rf ~/bitcoin-installation
```

<!--
```
# Grab rpcauth helper, verify by sha256sum
wget https://github.com/bitcoin/bitcoin/raw/v0.17.1/share/rpcauth/rpcauth.py &&
echo "7d8e1ac7f26dd61086c5a0b9a008add5636c882bd0b1ebd897f0887482e02bee rpcauth.py" | sha256sum -c &&
chmod +x rpcauth.py
```
-->

### Configuring
Create and edit `bitcoin.conf`

```bash
mkdir ~/.bitcoin &&
gedit ~/.bitcoin/bitcoin.conf
```
Add the following and save:
```bash
server=1

# Connect via Tor, comment if you prefer to connect directly
proxy=127.0.0.1:9050

# No incoming connections (requires port forwarding or an hidden service)
nolisten=1

# For faster sync, set according to available memory. For example, with 8GB memory, something like dbcache=5000 might make sense. Check total memory with `free -m`.
# For reduced memory usage, this can be tuned down or removed once the initial sync is complete. The default is 300 (mb).
dbcache=1000

# Optional extended transaction index (takes more space, required for btc-rpc-explorer)
txindex=1

# Reduce storage requirements (won't work with btc-rpc-explorer)
# prune=50000 # ~6 months, 50GB

# Reduce bandwidth requirements (node won't show unconfirmed transactions)
# blocksonly=1
```

Also see [jlopp's bitcoin core config generator](https://jlopp.github.io/bitcoin-core-config-generator/).

<!--
Generate `rpcauth` credentials:

```bash
~/bitcoin-installation/rpcauth.py <username>
```

Copy the `rpcauth=...` line to `~/.bitcoin/bitcoin.conf` and take note of your password.
-->

### Running
```bash
bitcoind
```

To test bitcoind is running:
```bash
bitcoin-cli getblockchaininfo
```

## btc-rpc-explorer

### Installing
```bash
# Download source
git clone https://github.com/janoside/btc-rpc-explorer ~/btc-rpc-explorer &&
cd ~/btc-rpc-explorer &&
# Install user-wide
npm install -g
```

### Running
```bash
btc-rpc-explorer --basic-auth-password superSecretPassword
```

Then open http://localhost:3002/ and login with an empty username and your `superSecretPassword`.

## Electrum Wallet

### Installing

```bash
# Install dependencies
sudo apt-get install -y python3-setuptools python3-pyqt5 python3-pip &&

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
cp ~/eps/config.cfg_sample ~/eps/eps.cfg &&
gedit ~/eps/eps.cfg
```

Find your Master Public Key in electrum wallet (Wallet > Information) and add it to `eps.cfg` under `[master-public-keys]` as a new line with `{name}={xpubkey}`. `name` can be anything. (The sample config already has this line, uncomment and replace sample xpubkey).

Under `[electrum-server]`, change `host=127.0.0.1` to `host=0.0.0.0`.

Save `eps.cfg`

### Running
```bash
electrum-personal-server ~/eps/eps.cfg
```

When running for the first time, EPS will import the addresses and quit. You should start it again.

If you're importing an existing wallet with historical transactions, a rescan will be required: `electrum-personal-server-rescan ~/eps/eps.cfg`

> Note: Electrum Wallet will only connect to Electrum Personal Server once bitcoind is synced.

## c-lightning

### Installing
```bash
# Install dependencies
sudo apt install -y autoconf automake build-essential libtool libgmp-dev libsqlite3-dev net-tools zlib1g-dev &&

# Download source
git clone https://github.com/ElementsProject/lightning ~/lightning && cd ~/lightning &&
# Checkout v0.6.3 (latest stable)
git checkout v0.6.3 &&

# Add signing key
gpg --recv-keys 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1 &&
# Verify signature - should see: Good signature from "Rusty Russell <rusty@rustcorp.com.au>"
git verify-tag v0.6.3 &&

# Build
./configure && make &&

# Install system-wide (requires sudo password)
sudo make install
```
### Configuring
Create and edit `~/.lightning/config`

```bash
mkdir ~/.lightning &&
gedit ~/.lightning/config
```
Add the following and save:
```bash
# default network is testnet,"bitcoin" means mainnet
network=bitcoin

# connect via Tor, comment to connect directly
proxy=127.0.0.1:9050

# Peers won't be able to initiate the opening of new channels with this node (the node will initiate instead). To allow that, a static IP or a Tor hidden service must be configured.
autolisten=false

# uncomment to set your own (public) alias. By default a random one is chosen.
# for privacy reasons, it is recommended not to set a custom alias.
#alias=MyPublicNodeAlias
```
### Running
```bash
lightningd
```
To test c-lightning is running:
```bash
lightning-cli getinfo
```
### Backup
There are two important files to backup:

`~/.lightning/hsm_secret` must be backed up once.
`~/.lightning/lightningd.sqlite3` must be backed up regulary. 

To configure encrypted cloud backups with Keybase, [follow the instructions here](https://github.com/bitembassy/home-node/blob/master/lightning-backup.md).

## Spark Wallet

### Installing
```bash
# Create dir for installation files
mkdir ~/spark-installation && cd ~/spark-installation &&

# Download npm package
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.3/spark-wallet-0.2.3-npm.tgz &&
# Download signature
wget https://github.com/shesek/spark-wallet/releases/download/v0.2.3/SHA256SUMS.asc &&

# Add signing key
gpg --keyserver hkp://keyserver.ubuntu.com/ --recv-keys FCF19B67866562F08A43AAD681F6104CD0F150FC &&
# Verify signature - should show "Good signature from Nadav Ivgi <nadav@shesek.info>"
gpg --verify SHA256SUMS.asc &&
# Verify the downloaded binary matches the signed hash in SHA256SUMS.asc
grep spark-wallet-0.2.3-npm.tgz SHA256SUMS.asc | sha256sum -c - &&

# Install user-wide
npm install -g spark-wallet-0.2.3-npm.tgz &&

# Cleanup installation files
rm -rf ~/spark-installation
```

### Running
```bash
spark-wallet --pairing-url
```

Spark will automatically generate random credentials and save them to `~/.spark-wallet/cookie`.

The `--pairing-url` option will print the pairing url, which includes your wallet access key. You can open this URL to access your wallet.
It will look like that: `http://localhost:9737/?access-key=[...]`.

You may also use `--pairing-qr` to print a qr with the pairing url (useful for mobile access).

## SSH access
```bash
sudo ufw allow ssh &&
sudo apt-get install -y openssh-server &&

# disable root login, disable password auth
sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config &&
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config &&
sudo service ssh reload
# TODO: set nonstandard SSH port? instructions for setting up keys?
```

## Tor Hidden Services

Edit `/etc/tor/torrc`, add:

```
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServiceVersion 3
HiddenServicePort 50002 127.0.0.1:50002
HiddenServicePort 3002 127.0.0.1:3002
HiddenServicePort 9737 127.0.0.1:9737
HiddenServicePort 22 127.0.0.1:22
```

Then restart with: `sudo service tor restart`

To get your `.onion` hostname: `sudo cat /var/lib/tor/hidden_service/hostname`

