require 'hashr'
require 'redch/config'

class Redch::Setup
  def initialize
    Redch::SOS::Client.configure do |config|
      config.namespace = 'http://www.redch.org/'
      config.intended_app = 'energy'
    end

    @sensor = Redch::SOS::Client::Sensor.new
  end

  def run
    raise StandardError, "device id and location must be specified" unless device_id && location

    begin
      register_device(device_id, location) unless done?
      store_config config
    rescue StandardError => e
      puts e.message
    end
  end

  def config
    @config ||= Redch::Config.load rescue Hashr.new
  end

  def location=(location)
    if config.sos?
      config.sos.location = location
    else
      config.sos = { location: location }
    end
  end

  def location
    return config.sos.location if config.sos?
    nil
  end

  def device_id=(id)
    if config.sos?
      config.sos.device_id = id
    else
      config.sos = { device_id: id }
    end
  end

  def device_id
    return config.sos.device_id if config.sos?
    nil
  end

  # If it has been executed the config file must exist
  def done?
    Redch::Config.load
    true
  rescue StandardError
    false
  end

  def sensor(id)
    {
      id: id,
      sensor_type: "in-situ",
      observation_type: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
      foi_type: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint',
      observable_prop_name: 'Photovoltaics',
      observable_prop: 'http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics'
    }
  end

  def store_config(config)
    Redch::Config.save(config)
  end

  def register_device(id, location)
    @sensor.create sensor(id)
  end
end
