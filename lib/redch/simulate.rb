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
      puts "Registering device..."
      setup.run
    end

    @device_id = Redch::Config.load.sos.device_id
    @sos_client = Redch::SOS::Client.new
    @loop = Redch::Loop.new(@interval)
  end

  def run
    puts "Sending an observation every #{@interval} seconds...\n\n"

    @loop.start do
      value = generate_value.round(3)
      begin
        @sos_client.post_observation observation(value)
        puts "Observation with value #{value} sent"
      rescue Exception => e
        puts e.message
        @loop.stop
      end
    end
  end

  def observation(value)
    {
      sensor: @device_id,
      samplingPoint: '54.9 10.52',
      observedProperty: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
      featureOfInterest: "http://www.redch.org/test/featureOfInterest/#{@device_id}",
      result: value,
      timePosition: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
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
      value = [value - var, 0].max
    end
  end
end
