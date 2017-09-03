#!/usr/bin/env bash

STARTUP_VERSION=1
STARTUP_MARK=/var/startup.script.$STARTUP_VERSION

# Exit if this script has already ran
if [[ -f $STARTUP_MARK ]]; then
  exit 0
fi

set -o nounset
set -o pipefail
set -o errexit

#Verify this is the correct path for your OS flavor
POSTGRES_VER=9.6
POSTGRES_HOME=/etc/postgresql/"$POSTGRES_VER"
POSTGRES_CONF="$POSTGRES_HOME"/main/postgresql.conf

# Add in timescale PPA
sudo add-apt-repository ppa:timescale/timescaledb-ppa
sudo apt-get update

# Install timescale
sudo apt-get install -y  timescaledb

sudo sed -i "s/#\(shared_preload_libraries *= *\).*/\1'timescaledb'/" $POSTGRES_CONF

sudo sed -i "s/#\(listen_addresses *= *\).*/\1'*'/" $POSTGRES_CONF

# Restart PostgreSQL instance
sudo service postgresql restart

# Add a superuser postgres:
# This is not required on Ubuntu as the postgres user account already exists.
#sudo createuser postgres -s

touch $STARTUP_MARK

echo Done!!!