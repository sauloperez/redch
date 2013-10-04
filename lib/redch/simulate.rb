require 'redch/sos'
require 'redch/setup'
require 'redch/loop'
require 'eventmachine'

class Redch::Simulate
  include Redch::Helpers

  def initialize(mean = 0.1, dev = 0.1, interval = 2)
    @mean = mean
    @dev = dev
    @interval = interval

    setup = Redch::Setup.new
    if !setup.done? 
      print_and_flush "Registering device..."
      setup.run
      puts " DONE"
    end

    @device_id = Redch::Config.load.sos.device_id
    @sos_client = Redch::SOS::Client.new
    @loop = Redch::Loop.new(@interval)
  end

  def run
    puts "Sending an observation every #{@interval} seconds...\n\n"

    @loop.start do
      value = generate_value.round(3)
      @sos_client.post_observation observation(value)
      puts "Observation with value #{value} sent"
    end
  end

  def observation(value)
    {
      sensor: @device_id,
      observedProperty: 'urn:ogc:def:property:OGC:1.0:precipitation',
      featureOfInterest: 'http://www.52north.org/test/featureOfInterest/9',
      result: value,
      timePosition: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
      offering: "http://www.example.org/offering/#{@device_id}/observations"
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
      value = [value - var, 0].max
    end
  end
end