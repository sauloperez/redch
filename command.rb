require "./lib/producer"

module Command

  # Sensor data generation
  # values taken from: http://www.recgroup.com/en/aboutsolar/basic-solar-maths/
  # All power values are in kWh
  class Generate
    attr_accessor :mean, :dev, :interval

    def initialize(routing_key, options = {})
      @routing_key = routing_key

      # Contains the default params and it's used as a whitelist
      @params = {
        mean: 0.1, # Considering a high irradiation area
        dev: 0.1, # 10% of standard deviation
        interval: 1 # time between samples (in seconds)
      }

      # Set the params as instance variables
      @params.each { |k, v| instance_variable_set("@#{k}", v) }

      # Update these instance variables with the provided options 
      # It only allows keys included in the whitelist
      options.each { |k, v| instance_variable_set("@#{k}", v) if params.key? k }
    end

    public
    def run
      AMQP.start("amqp://guest:guest@dev.rabbitmq.com") do |connection, open_ok|        
        # Connect to a channel with a direct exchange
        producer = Producer.new(AMQP::Channel.new(connection), AMQP::Exchange.default)

        puts "Publishing sensor data..."

        # Output a sample every interval indefinitely
        EventMachine.add_periodic_timer(1) do
          # Publish some data in it and make it route by the key 'sensor.samples'
          producer.publish("#{'%.3f' % generate_value} kWh", :routing_key => @routing_key)
        end
      end
    end

    protected

    # Generates random power values in kWh
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
end