class Redch::Setup
  def initialize
    @config = Redch::Config.load
  end

  def run
    register_device if @config.empty? || !@config.sos.device_id?
  end

  def device_id
    return @config.sos.device_id if @config.sos?
    nil
  end

  def register_device
    sos_client = Redch::SOS::Client.new
    store_device_id sos_client.register_device(Mac.addr)
  end

  private
  def store_device_id(id)
    if @config.sos? 
      @config.sos.device_id = id
    else
      @config = Hashr.new(sos: { device_id: id })
    end
    Redch::Config.save(@config)
  end  
end