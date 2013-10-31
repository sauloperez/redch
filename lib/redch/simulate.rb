require 'redch/sos'
require 'redch/setup'
require 'redch/loop'
require 'eventmachine'

class Redch::Simulate
  include Redch::Helpers

  attr_accessor :period

  # CHECK IT (MOVE IT TO CLI)
  def initialize(device_id, location, mean = 0.1, dev = 0.1, period = 2)
    @device_id = device_id
    @location = location

    @mean = mean
    @dev = dev
    @period = period

    @sos_client = Redch::SOS::Client.new
    @loop = Redch::Loop.new(@period)
  end

  def run(&block)
    @loop.start do
      begin
        value = generate_value.round(3)
        @sos_client.post_observation observation(value)
        yield(value) if block_given?
      rescue Exception => e
        puts e.message
        @loop.stop
      end
    end
  end

  def stop
    @loop.stop
  end

  def sos_client=(sos_client)
    @sos_client = sos_client
  end

  def observation(value)
    {
      sensor: @device_id,
      samplingPoint: @location.join(' '),
      observedProperty: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
      featureOfInterest: "http://www.redch.org/test/featureOfInterest/#{@device_id}",
      result: value,
      phenomenonTime: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
      resultTime: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
      offering: "http://www.redch.org/offering/#{@device_id}/observations"
    }
  end

  def generate_value
    value = @mean
    lowest = @mean - @mean*@dev
    highest = @mean + @mean*@dev
    var = Random.new.rand(lowest..highest)

    if [true, false].sample
      value += var
    else
      # Don't allow negative values
      value = [value - var, 0.0].max
    end
  end
end
