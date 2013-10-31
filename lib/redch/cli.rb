require 'redch'
require 'redch/helpers'
require 'redch/sos'
require 'redch/setup'
require 'redch/simulate'
require 'thor'
require 'macaddr'
require 'random-location'

class Redch::CLI < Thor
  include Thor::Actions

  def initialize(*args)
    super
    install_traps
  end

  desc "setup", "Sets up the environment to enable the use of the device"
  def setup
    setup = Redch::Setup.new
    setup.location= RandomLocation.near_by(41.65038, 1.13897, 5_000)
    
    # It's the only way to not mess up the yaml
    # and avoid a Psych::BadAlias exception
    id = Mac.addr.dup 
    setup.device_id= id

    say("Registering device...")
    setup.run
  end

  desc "simulate", "Simulate a sensor generating kWh sensor data samples"
  def simulate
    setup
    config = Redch::Config.load
    simulate = Redch::Simulate.new(config.sos.device_id, config.sos.location)

    say("Sending an observation every #{simulate.period} seconds...")
    simulate.run do |value|
      say("Observation with value #{value} sent")
    end
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
