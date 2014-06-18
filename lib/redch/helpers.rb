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

    # Generates IEEE locally-assigned MAC addresses
    #
    # @return [String] following the pattern [0-9A-Fa-f][26AEae][0-9A-Fa-f]{10}
    def mac
      mac = ('%0.2X' % rand(256))[0, 1] + %w(2 6 A E).sample
      mac << (1..5).map { "%0.2X" % rand(256) }.join
    end

    def delete_config_file
      filename = Redch::Config.filename
      File.delete(filename) if File.exist?(filename)
    end

    def put_coords(coords)
     "(" << "%.5f" % coords[0] << ", " << "%.5f" % coords[1] << ")"
    end

    def last_segment(uri)
      uri.match(/([^\/]+$)/)[0]
    end
  end
end
