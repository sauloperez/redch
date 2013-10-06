require 'rest_client'
require 'redch/error'
require 'logger'
require 'nokogiri'
require 'nori'
require 'slim/logic_less'
require 'yaml'
require 'pp'

module Redch
  module SOS

    class Client

      include Redch::Helpers

      attr_reader :device_id

      VERSION = '2.0'

      @headers = {
        content_type: "application/gml+xml",
        accept: "application/gml+xml"
      }

      def register_device(id)
        post_sensor sensor_profile(id)
      end

      def post_sensor(sensor)
        resource = sos_resource("/sensors")
        body = build(sensor, __method__)

        http_post(resource, body) do |response|
          parsed = @parser.parse response.body
          parsed['sosREST:Sensor']['sosREST:link'].each do |link|
            return last_segment(link['@href']) if last_segment(link['@rel']) == 'self'
          end
        end
      rescue Exception => e
        raise e
      end

      def post_observation(observation)
        resource = sos_resource("/observations")
        body = build(observation, __method__)

        http_post(resource, body) do |response|
          parsed = @parser.parse response.body
          parsed['sosREST:Observation']['sosREST:link']
        end
      end

      private
      def last_segment(uri)
        /([^\/]+$)/.match(uri)[0]
      end

      def build(data, operation)
        path = File.expand_path(File.join('../templates', "#{operation}.slim"), __FILE__)
        template = File.open(path, "r").read

        layout = Slim::Template.new { template }
        layout.render(data)
      end

      def sensor_profile(id)
        {
          uniqueID: id,
          intendedApplication: 'energy',
          sensorType: 'in-situ',
          beginPosition: '2009-01-15',
          endPosition: '2009-01-20',
          featureOfInterestID: 'http://www.52north.org/test/featureOfInterest/9',
          observationType: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
          featureOfInterestType: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint'
        }
      end

      def generate_device_id
        random_MAC_address
      end

      def self.headers
        @headers
      end

      def http_get(resource, &block)
        yield resource.get self.class.headers
      end

      def http_post(resource, payload, &block)
        yield resource.post payload, self.class.headers
      rescue RestClient::RequestFailed => e
        if e.http_code == 400
          parsed = @parser.parse e.response
          exception = parsed['ows:ExceptionReport']['ows:Exception'][0] || parsed['ows:ExceptionReport']['ows:Exception']

          raise Redch::SOS::Error.new("#{exception['@exceptionCode']}: #{exception['ows:ExceptionText']}")
        end
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
