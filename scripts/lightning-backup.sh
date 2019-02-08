#!/bin/bash

# !! WARNING !!
# 
# Recovering lightning channel state is currently unsupported by the lightning
# node software and is considered dangerous. Recovering from an outdated backup
# could lead to LOSS of funds. DO NOT attempt to restore this backup on your own.
# Please seek expert help before doing anything. These might be good places to start:
# 
# - IRC: #c-lightning at Freenode (https://webchat.freenode.net/?channels=c-lightning)
# - The c-lightning issue tracker on GitHub (https://github.com/ElementsProject/lightning/issues)
# - The Tel-Aviv Bitcoin Embassy (https://www.bitembassy.org/, https://www.facebook.com/bitcoin.embassy.tlv/)
# 
# !! WARNING !!

set -xeo pipefail

KEEP_DAYS=7
KEEP_WEEKS=7
DB_PATH=$HOME/.lightning/lightningd.sqlite3
BACKUP_DIR=$HOME/backups

copy_sqlite() {
  sqlite3 $1 ".backup '$2.TMP'"
  sqlite3 $2.TMP VACUUM
  gzip $2.TMP
  mv $2.TMP.gz $2.gz
}

mkdir -p $BACKUP_DIR
copy_sqlite $DB_PATH $BACKUP_DIR/latest.lightningd.sqlite3
cp $BACKUP_DIR/latest.lightningd.sqlite3.gz $BACKUP_DIR/daily.`date +%Y-%m-%d`.lightningd.sqlite3.gz
cp $BACKUP_DIR/latest.lightningd.sqlite3.gz $BACKUP_DIR/weekly.`date +%Y-%U`.lightningd.sqlite3.gz

ls -t $BACKUP_DIR/daily.* | tail -n +$((KEEP_DAYS+1)) | xargs -r rm
ls -t $BACKUP_DIR/weekly.* | tail -n +$((KEEP_WEEKS+1)) | xargs -r rm

egrep '^# ' $0 > $BACKUP_DIR/00-SEEK-EXPERT-HELP---DO-NOT-RESTORE-ON-YOUR-OWN
