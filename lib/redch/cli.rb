require 'redch'
require 'redch/gateway'
require 'thor'

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

  # Handle the shut down gracefully.
  # Save state or whatever needed
  def shut_down
    puts "\nBye"
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