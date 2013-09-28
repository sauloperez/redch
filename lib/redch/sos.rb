require 'rest_client'
require 'nori'

module Redch
  module SOS

    class Client
      def initialize
        @headers = { accept: "application/gml+xml" }
      end

      def get_capabilities
        resource = sos_resource("/capabilities")
        response = resource.get @headers
        @parser.parse response.body
      end

      def get_features
        resource = sos_resource("/features")
        response = resource.get @headers
        @parser.parse response.body
      end

      def get_feature(id)
        resource = sos_resource("/features/#{id}")
        response = resource.get @headers
        @parser.parse response.body
      end

      private
      def sos_host
        "localhost:8080"
      end

      def base_path
        "/webapp/sos/rest"
      end

      def sos_resource(path)
        @parser = Nori.new
        RestClient::Resource.new("http://#{sos_host}#{base_path}#{path}")
      end
    end

  end
end
