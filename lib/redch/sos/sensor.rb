module Redch::SOS
  module Client

    class Sensor
      attr_accessor :params

      def initialize(options = {})
        @params = options
      end

      def create(id)
        id
      end

      def base_uri
        URI
      end
    end

  end
end
