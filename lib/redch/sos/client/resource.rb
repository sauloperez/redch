require 'client'
require 'rest_client'
# require 'nokogiri'
require 'nori'

module Redch::SOS
  module Client

    class Resource
      include Helpers

      attr_reader :id
      attr_accessor :params, :headers

      @@resource_paths = {}

      def initialize(options = {})
        @params = options
        @headers = {
          content_type: "application/gml+xml",
          accept: "application/gml+xml"
        }
      end

      def self.resource(path = nil)
        return @@resource_paths[self] if path.nil?
        @@resource_paths[self] = path
      end

      def self.base_uri
        URI
      end

      def base_uri
        URI
      end

      def http_post(payload = nil, &block)
        path = base_uri + @@resource_paths[self.class]
        resource = RestClient::Resource.new(path)
        parser = Nori.new

        response = resource.post(payload, headers)
        parsed_body = parser.parse response.body

        yield parsed_body if block_given?
      rescue RestClient::RequestFailed => e
        case e.http_code
          when 400      then raise Client::BadRequest
          when 404      then raise Client::NotFound
          when 500..599 then raise Client::ServerError
          else raise Client::Error
        end
      end
    end

  end
end
