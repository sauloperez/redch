module Redch::SOS
  module Client

    class Resource
      attr_reader :id
      attr_accessor :params

      def initialize(options = {})
        @params = options
      end

      def base_uri
        URI
      end

      def http_post(sos_resource, payload = nil, &block)
        yield "response" if block_given?
      end
    end

  end
end