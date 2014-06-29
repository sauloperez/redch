#!/usr/bin/env bash

# Provision and install a redch client in ubuntu
# Run as: provisioning.sh <latitude>, <longitude> 

DIR=/home/vagrant/redch
URL=http://54.72.170.113:8080/webapp/sos/rest
BIN_DIR=/usr/local/bin
BRANCH=master
REDCH_BIN=$BIN_DIR/redch
PROFILE_SCRIPT=/etc/profile.d/redch.sh

set -e # Exit script immediately on first error.
set -x # Print commands and their arguments as they are executed.

# After booting for first time...
sudo apt-get update

# Nokogiri requirements
sudo apt-get install -y libxslt-dev libxml2-dev

# Set up required environment variables
if [ ! -f $PROFILE_SCRIPT ]; then
  sudo echo "export PATH=$PATH:$BIN_DIR"
  sudo echo "export REDCH_LOCATION='$1'" >> $PROFILE_SCRIPT
  sudo echo "export REDCH_SOS_URL=$URL" >> $PROFILE_SCRIPT
  source /etc/profile
fi

# Install bundler
bundle -v > /dev/null 2>&1 || sudo gem install bundler

function install_cli {
  git clone --depth 1 --branch $BRANCH https://github.com/sauloperez/redch.git $DIR
  sudo chown -R vagrant:vagrant $DIR
  sudo su vagrant -c "cd $DIR; bundle install --without development test"
}

# Check if the source code must be updated
if [ -d $DIR ]; then
  cd $DIR

  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})

  # Remove any previous installation
  if [ $LOCAL != $REMOTE ]; then
    test -d $DIR && rm -rf $DIR
    install_cli
  fi
else
  install_cli
fi

# Symlink it to make it globally accessible
if [ ! -L $REDCH_BIN ]; then
  ln -s $DIR/bin/redch $REDCH_BIN
fi

