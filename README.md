# Redch CLI Client

This simple Ruby application simulates a sensor device client for the project Redch. It is built as a command-line wrapper around the [Sensor Observation Service](https://github.com/sauloperez/sos) client that sensor devices will be shipped with.

## Installation

You must clone the repo

    $ git clone git@github.com:sauloperez/redch.git

Although not mandatory, it is highly recommended to add the executable in your PATH environment variable. To do so, create a softlink in a suitable system folder pointing to `/bin/redch` of the previously cloned repository. In Mac OS X `/usr/local/bin` might be a good choice. You can do that with the following command:

    $ ln -s ~/redch/bin/redch /usr/local/bin/.

Then, make sure your PATH variable looks up into the folder that contains the softlink. If not, add it. Doing so `redch` will be globally accessible.

In case of working with Bash shell this should be set in the `~/.bash_profile` file. Find further details in [.bash_profile vs .bashrc](http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html)

    # Prepend the variable with the right path
    PATH="/usr/local/bin:/usr/local/sbin:$PATH"

Lastly, load the changes

    $ source ~/.bash_profile


## Usage

The command-line interface comes with the methods `setup` and `simulate` that you can use as follows.

### Setup

If no coordinates are provided, the `setup` command will pick up a random location near by Tàrrega within a range of 90 Km as the sensor location. It uses the first MAC address of the system as device unique identifier.

    $ redch setup -c '41.65, 2.13'

### Simulate

The `simulate` command loads the configuration set by the `setup` and issues randomly generated observations for each time period indefinitely. If not specified a period of 2 seconds will be used.

    # Issue a post request each second
    $ redch simulate -p 1

If the setup defaults suit you, you can skip the `setup` and just type the `simulate` command. It always executes the setup before the simulation if no configuration is found. 
	
	# Set up the sensor with its defaults and simulate observations
	$ redch simulate

### Help

You can always list the available commands with the `help` command or the `-h` flag

    $ redch help
	Commands:
	  redch help [COMMAND]  # Describe available commands or one specific command
	  redch setup           # Sets up the environment to enable the use of the device
	  redch simulate        # Simulate a sensor generating electrical power samples in W

Or find out the details of a particular command

    $ redch help setup
    Usage:
      redch setup

    Options:
      c, [--coordinates=COORDINATES]

    Sets up the environment to enable the use of the device


