
## Backup the c-lightning database with Keybase
The c-lightning database should be backed-up on a regular basis so channels and their state can be restored in case of a data loss.

> Note: we are using Keybase (which is relatively new) for encrypted cloud backups. Make sure you feel comfortable with that and begin by installing the [app on your phone](https://keybase.io/download) and creating an account.

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

# install and run
sudo dpkg -i keybase_amd64.deb &&
sudo apt-get install -f &&
run_keybase
```
### Login
Assuming you already have the app installed on your phone and an account configured:
Press login, enter your Keybase user name, select your phone from the list of existing devices, select a name for this computer. A QR should be displayed. 
On your phone, open the Keybase app, in the the menu select Devices, select Add New Computer and scan the QR.

If you dont have an account on another device you may create a new one insted of login.


### Create backup script
Create a backup script
```
gedit ~/.lightning/keybase_backup
```

Add the following and save - note: you need to replace the text in [] with your user name.
```bash
#!/bin/bash
cp ~/.lightning/testbackup.sqllite3 /keybase/private/[YOUR KEYBASE USER NAME]]/lightningd.sqlite3
```
Make it executable:
```
chmod +x ~/.lightning/keybase_backup
```
### Add an hourly cronjob to run the script
Open crontab editor with:
```
crontab -e
```

Add the following line at the bottom and save:
```
@hourly ~/.lightning/keybase_backup
```
