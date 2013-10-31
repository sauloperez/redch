require 'eventmachine'

class Redch::Loop
  def initialize(period)
    raise ArgumentError.new("the time period must be especified") if period.nil?
    @period = period # seconds
  end

  def start(&block)
    EventMachine.run do

      EventMachine.add_periodic_timer(@period) do
        begin
          yield
        rescue StandardError => e
          EventMachine.stop
          raise e
        end
      end

    end
  end

  def stop(&block)
    return if !EventMachine::reactor_running?

    yield if block_given?
    EventMachine.stop
  end
end
