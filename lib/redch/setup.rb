require 'hashr'
require 'redch/config'

class Redch::Setup
  def initialize
    @config = Redch::Config.load rescue Hashr.new
    @sos_client = Redch::SOS::Client.new
  end

  def run
    register_device(device_id) if !done?
  rescue ArgumentError => e
    raise StandardError, "No device id specified"
  end

  def location=(location)
    if @config.sos?
      @config.sos.location = location
    else
      @config.sos = { location: location }
    end
  end

  def location
    return @config.sos.location if @config.sos?
    nil
  end

  def device_id=(id)
    if @config.sos?
      @config.sos.device_id = id
    else
      @config.sos = { device_id: id }
    end
  end

  def device_id
    return @config.sos.device_id if @config.sos?
    nil
  end

  def sos_client=(sos_client)
    @sos_client = sos_client
  end

  # If it has been executed the config file must exist
  def done?
    Redch::Config.load
    true
  rescue StandardError
    false
  end

  private
  def store_config(config)
    Redch::Config.save(config)
  end

  def register_device(id)
    raise ArgumentError.new if id.nil?
    raise StandardError, "No location specified" if location.nil?

    @sos_client.register_device(id)
    store_config @config
  end
end
