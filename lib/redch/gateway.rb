require 'redch/producer'

module Redch
  
  class Gateway
    def initialize(api_key, interval)
      @routing_key = "sensor.samples"
      @api_key = api_key
      @interval = interval
    end  

    def send_samples(&generate_value)
      begin
        AMQP.start("amqp://guest:guest@dev.rabbitmq.com") do |connection, open_ok|  

          # Connect to a channel with a direct exchange
          producer = Producer.new(AMQP::Channel.new(connection), AMQP::Exchange.default)

          puts "Publishing sensor data..."

          # Output a sample every interval indefinitely
          EventMachine.add_periodic_timer(@interval) do

            # Call the proc to generate a new sample and build a message
            sample = generate_value.call
            message = { api_key: @api_key, measurement: "#{'%.3f' % sample} kWh" }

            # Publish the message and make it route by the key 'routing_key'
            producer.publish(message, routing_key: @routing_key)
          end
        end
      rescue Interrupt
        raise Interrupt
      end
    end
  end
end