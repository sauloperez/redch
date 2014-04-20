require 'redch/sos'
require 'redch/setup'
require 'redch/loop'
require 'eventmachine'

class Redch::Simulate
  include Redch::Helpers

  attr_accessor :period, :mean, :dev

  # CHECK IT (MOVE IT TO CLI)
  def initialize(device_id, location)
    @device_id = device_id
    @location = location

    @mean = 6
    @dev = 0.5
    @period = 2 # Timespan between observation requests

    Redch::SOS::Client.configure do |config|
      config.namespace = 'http://www.redch.org/'
      config.intended_app = 'energy'
    end

    @observation = Redch::SOS::Client::Observation.new
    @loop = Redch::Loop.new(@period)
  end

  def run(&block)
    @loop.start do
      begin
        value = generate_value(@mean, @dev).round(3)
        register_observation(value)
        yield(value) if block_given?
      rescue StandardError => e
        @loop.stop
        raise e
      end
    end
  end

  def stop
    @loop.stop
  end

  def observation(value)
    {
      sensor_id: @device_id,
      location: @location,
      observed_prop: 'http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics',#'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
      result: value,
      timespan: [Time.now - @period, Time.now],
      time: Time.now
    }
  end

  def register_observation(value)
    @observation.create observation(value)
  end

  def generate_value(mean, dev)
    value = mean
    lowest = mean - mean*dev
    highest = mean + mean*dev
    var = Random.new.rand(lowest..highest)

    if [true, false].sample
      value += var
    else
      # Don't allow negative values
      value = [value - var, 0.0].max
    end
    value
  end
end
