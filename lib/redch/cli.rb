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
  end

  private
  def generate_value
    value = @mean
    lowest = @mean - @mean*@dev
    highest = @mean + @mean*@dev
    var = Random.new.rand(lowest..highest)

    if [true, false].sample
      value += var
    else
      # Don't allow negative values
      value = [value - var, 0].max
    end
  end
end
