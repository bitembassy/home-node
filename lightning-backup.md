## Backup the c-lightning database

```bash
sudo apt install -y sqlite3
```

TODO: backup script

## Backup the c-lightning database with Keybase
The c-lightning database should be backed up on a regular basis so channels and their states can be restored in case of a data loss. Note: we are using Keybase (which is relatively new) for encrypted cloud backups. Make sure you feel comfortable with that and begin by installing the [app on your phone](https://keybase.io/download) and creating an account.

### Install Keybase
```
# Create dir for installation files
mkdir ~/keybase-installation && cd ~/keybase-installation &&

# Download packdge 
wget https://prerelease.keybase.io/keybase_amd64.deb &&
# Download signature
wget https://prerelease.keybase.io/keybase_amd64.deb.sig &&

# Add signing key
gpg --recv-keys 222B85B0F90BE2D24CFEB93F47484E50656D16C7 &&
# Verify signature - should see: Good signature from "Keybase.io Code Signing (v1) <code@keybase.io>"
gpg --verify keybase_amd64.deb.sig keybase_amd64.deb &&

# Install system-wide (requires sudo)
sudo apt install -y ./keybase_amd64.deb
```

Keybase can now be opened from the lauancher.

### Login
Assuming you already have the app installed on your phone and an account configured:
press login, enter your Keybase user name, select your phone from the list of existing devices, select a name for this computer. A QR should be displayed. 

On your phone, open the Keybase app, in the the menu select Devices, select Add New Computer and scan the QR.

If you dont have an account on another device, you may create a new one insted of login.

### Move Database to Keybase Backup Directory

Stop c-lightning:
```
lightning-cli stop
```

Move database to the Keybase directory and create symbolic link in the original directory:
Note: you need to replace `[MY KEYBASE USER NAME]` with your user name.
```
mv ~/.lightning/lightningd.sqlite3 /keybase/private/[MY KEYBASE USER NAME]/lightningd.sqlite3
ln -s /keybase/private/[MY KEYBASE USER NAME]/lightningd.sqlite3 ~/.lightning/lightningd.sqlite3 
```

Start c-lightning:
```
lightningd
```

### Backup your hsm_secret
The `~/.lightning/hsm_secret` file holds private keys required to accsses funds. It must be backed up, but just once. If you have a safer way to keep a copy, you may skip this step. 

Otherwise, run the following so it's backed up to your `private` Keybase folder together with the lightning database.

Note: you need to replace `[YOUR KEYBASE USER NAME]` with your user name.

```
cp ~/.lightning/hsm_secret /keybase/private/[YOUR KEYBASE USER NAME]/hsm_secret
```
