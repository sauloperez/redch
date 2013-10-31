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
          featureOfInterestID: "http://www.redch.org/test/featureOfInterest/#{id}",
          observationType: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
          featureOfInterest: "http://www.redch.org/test/featureOfInterest/#{id}",
          featureOfInterestType: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint',
          observablePropertyName: 'SolarPanelEnergyProduction',
          observableProperty: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel'
        }
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
        message = ""
        
        case e.http_code
        when 400
          message = "SOS Bad Request"
        # when 500
        #   messahe = "SOS Internal Server Error"
        when 503
          message = "SOS Service Unavailable"
        when nil
          message = e
        else
          parsed = @parser.parse e.response
          if parsed.has_key?('ows:ExceptionReport')
            ows_exception = parsed['ows:ExceptionReport']['ows:Exception']
            exception = ows_exception[0] || ows_exception
            message = "#{exception['@exceptionCode']}: #{exception['ows:ExceptionText']}"
          end
        end
        raise Redch::SOS::Error.new(message)
      end

      def http_put(resource, &block)
        yield resource.put self.class.headers
      end

      def http_delete(resource, &block)
        yield resource.delete self.class.headers
      end

      def default_port
        ":8080"
      end

      def default_host
        "localhost"
      end

      def default_base_path
        "/webapp/sos/rest"
      end

      def sos_endpoint(path)
        host = ENV["SOS_HOST"] || default_host
        "http://#{host}#{default_port}#{default_base_path}#{path}"
      end

      def sos_resource(path)
        @parser = Nori.new
        RestClient::Resource.new sos_endpoint(path)
      end
    end

  end
end
