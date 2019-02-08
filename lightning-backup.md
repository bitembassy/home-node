## Backup the c-lightning database
The c-lightning database should be backed up regulary as it might be required in order to recover funds in case of a data loss.

> Warning: Do not try to restore a database backup yourself! Using an out-of-date database as-is may lead to lost funds. The restore proccess is out of scope here and currently requires an expert help.

### Create a backup script

Install sqlite
```bash
sudo apt install -y sqlite3
```

Fetch the `lightning-backup.sh` script:

```bash
wget -O ~/lightning-backup.sh https://raw.githubusercontent.com/bitembassy/home-node/master/scripts/lightning-backup.sh &&
echo "0e09c0de0647fe092edcec5598f50f19f082dc172048b900d7fc531a492855ae $HOME/lightning-backup.sh" | sha256sum -c
```

You can change the directory backups will be saved to by editing `~/lightning-backup.sh` and changing `BACKUP_DIR`
(defaults to `~/backups`).

> Note: You probably want to use at least a different media for the destination. For cloud backups use encryption as the database content is sensetive. See our [Keybase backup instructions](https://github.com/bitembassy/home-node/blob/master/lightning-backup.md#encrypted-cloud-backup-with-keybase) for an example of such.

### Set an hourly cronjob to run the script
Open crontab editor with:
```
crontab -e
```
Add the following line at the bottom and save.
```
@hourly ~/lightning-backup.sh
```

## Encrypted cloud backup with Keybase
Note: we are using Keybase (which is relatively new) for encrypted cloud backups. Make sure you feel comfortable with that and you may begin by installing the [app on your phone / laptop](https://keybase.io/download) and creating an account. This will make it easier to login the node by scanning a QR.

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

### Login and add this computer as a new device
You may login using the UI (run Keybase from the launcher) or using the command-line.
Assuming you already have the app installed on your phone and an account configured:

Using the UI, press login, enter your Keybase user name, select your phone from the list of existing devices, select a name for this computer. A QR should be displayed. 

Or using the command-line: 
```
keybase login
```
And follow similar steps to get the pairing QR in the terminal.

On your phone, open the Keybase app, in the the menu select Devices, select Add New Computer and scan the QR.

If you dont have an account on another device, you may create a new one insted of login.

### Set Keybase `private` folder as the backup destination

Edit the [script from previous step](https://github.com/bitembassy/home-node/blob/master/lightning-backup.md#create-a-backup-script), change `BACKUP_DIR` to: `/keybase/private/[YOUR KEYBASE USER NAME]`.

Note: don't forget to replace `[YOUR KEYBASE USER NAME]` with your user name.


## Backup your hsm_secret
The `~/.lightning/hsm_secret` file holds private keys required to accsses funds. It must be backed up, but just once. If you have a safer way to keep a copy, you may skip this step. 

Otherwise, run the following so it's backed up to your `private` Keybase folder together with the lightning database.

Note: you need to replace `[YOUR KEYBASE USER NAME]` with your user name.

```
cp ~/.lightning/hsm_secret /keybase/private/[YOUR KEYBASE USER NAME]/hsm_secret
```
