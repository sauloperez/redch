module Redch
  module Helpers

    def retry_on_exception(*exceptions)
      retry_count = 0
      begin
        yield
      rescue *exceptions => e
        raise e if retry_count >= 3
        sleep 3
        retry_count += 1
        retry
      end
    end

    # return a random valid MAC address
    def get_MAC_address
      (1..6).map { "%0.2X"%rand(256) }.join(':')
    end
  end
end
