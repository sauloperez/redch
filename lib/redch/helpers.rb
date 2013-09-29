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

  end
end
