require 'redch'
require 'redch/helpers'
require 'redch/sos'
require 'redch/setup'
require 'redch/simulate'
require 'thor'
require 'macaddr'
require 'yaml'
require 'pp'

class Redch::CLI < Thor

  def initialize(*args)
    super
    install_traps
  end

  desc "setup", "Sets up the environment to enable the use of the device"
  def setup
    Redch::Setup.new.run
  end

  desc "simulate", "Simulate a sensor generating kWh sensor data samples"
  def simulate
    Redch::Simulate.new.run
  end

  # Methods not listed as commands
  no_commands do
    # Handle the shut down gracefully.
    # Save state or whatever needed
    def shut_down
      puts "\nBye"
    end

    def install_traps
      [:INT, :TERM].each do |signal|
        trap signal do
          shut_down
          exit 1
        end
      end
    end
  end
end
