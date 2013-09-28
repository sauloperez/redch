require 'redch'
require 'redch/gateway'
require 'redch/sos'
require 'thor'
require 'pp'

class Redch::CLI < Thor

  desc "simulate DEVICE_ID", "Simulate a sensor generating kWh sensor data samples"
  def simulate(device_id = 1)
    begin
      @mean = 0.1
      @dev = 0.1
      @interval = 1

      # Send the data specifing the device api key
      gateway = Redch::Gateway.new(ENV["REDCH_KEY_#{device_id}"], @interval)

      # Define a proc to be called each time interval
      value = Proc.new { generate_value }
      gateway.send_samples(&value)
    rescue Interrupt
      shut_down
    end
  end

  desc "sos METHOD", "TEST SOS service callS"
  def sos(method, id = nil)
    sos_client = Redch::SOS::Client.new
    if id.nil?
      pp sos_client.send method
    else
      pp sos_client.send method, id
    end
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
