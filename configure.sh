# Tell Rubygems not to install the documentation for each package locally
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Install bundler to manage Redch dependencies.
# Be sure you have write access to RVm gems folder
gem install bundler

# Move on. Let's install Redch
git clone https://github.com/sauloperez/redch.git
chmod 755 ~/redch/bin/redch
ln -s ~/redch/bin/redch /usr/local/bin/redch
cd ~/redch

# Install the dependencies
bundle install

# Configure the environment
echo 'export SOS_HOST="192.168.0.1"' >> ~/.bashrc
exec $SHELL # Does it start up a new shell session?

# Set up the sensor as a client with a random location
# and start sending random observations
redch simulate
