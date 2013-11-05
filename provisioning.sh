#!/usr/bin/env bash

# System update and install common libraries
cd
sudo apt-get update
sudo apt-get install build-essential libreadline-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev 
sudo apt-get install curl
sudo apt-get install git-core git

# Install RVM
\curl -L https://get.rvm.io | sudo bash -s stable --autolibs=3 --ruby=1.9.3

# start up a new shell session
source /usr/local/rvm/scripts/rvm

# Avoid annoying 'RVM is not a function' error. Allows login shell
# /bin/bash --login

# and let RVM install its dependencies
rvm requirements

# Install ruby and use the version we install
rvm install 1.9.3
rvm use 1.9.3

# We can't live without ruby gems!
rvm rubygems current

# Tell Rubygems not to install the documentation for each package locally
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Install bundler
gem install bundler


# Move on. Let's install and run Redch
# Install it
git clone https://github.com/sauloperez/redch.git
chmod 755 ~/redch/bin/redch
ln -s /root/redch/bin/redch /usr/local/bin/redch
cd ~/redch
bundle install

# Configure the environment
echo 'export SOS_HOST="192.168.0.1"' >> ~/.bashrc
exec $SHELL # Does it start up a new shell session?

# Set the sensor up as a client with a random location
# and start sending random observations
redch simulate
