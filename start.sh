#!/usr/bin/env bash

URL=http://54.72.170.113:8080/webapp/sos/rest
CONF_FILE=/home/vagrant/.redch.yml

echo 'Setting up and running...'

# Setup and run redch
if [ ! -f $CONF_FILE ]; then
  sudo su - vagrant -c "REDCH_SOS_URL=$URL; /usr/local/bin/redch setup --coordinates '`echo $REDCH_LOCATION`'"
fi
sudo su - vagrant -c "REDCH_SOS_URL=$URL; /usr/local/bin/redch simulate > redch.log 2>&1 &"
