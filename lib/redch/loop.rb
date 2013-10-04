require 'eventmachine'

class Redch::Loop
  def initialize(interval = nil)
    @interval = interval
  end

  def start(&block)
    EventMachine.run do

      if !@interval.nil?
        EventMachine.add_periodic_timer(@interval) do
          begin
            yield
          rescue StandardError => e
            EventMachine.stop
            raise e
          end
        end
      else
        yield
      end

    end
  end

  def stop(&block)
    return if !EventMachine::reactor_running?

    yield
    EventMachine.stop
  end
end