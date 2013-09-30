require 'rest_client'
require 'logger'
require 'nokogiri'
require 'nori'
require 'slim/logic_less'
require 'pp'

module Redch
  module SOS
    VERSION = '2.0'

    class Client
      include Redch::Helpers

      @headers = {
        content_type: "application/gml+xml",
        accept: "application/gml+xml"
      }

      def post_sensor(sensor_profile)
        resource = sos_resource("/sensors")
        body = build(sensor_profile)
        http_post(resource, body) do |response|
          parsed = @parser.parse response.body
          parsed['sosREST:Sensor']['sosREST:link']
        end
      end

      private
      def build(sensor_profile)
        path = File.expand_path(File.join('../templates', 'post_sensor.slim'), __FILE__)
        template = File.open(path, "r").read

        layout = Slim::Template.new { template }
        layout.render(sensor_profile)
      end

      def self.headers
        @headers
      end

      def http_get(resource, &block)
        yield resource.get self.class.headers
      end

      def http_post(resource, payload, &block)
        yield resource.post payload, self.class.headers
      rescue => e
        e.response
      end

      def http_put(resource, &block)
        yield resource.put self.class.headers
      end

      def http_delete(resource, &block)
        yield resource.delete self.class.headers
      end

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
