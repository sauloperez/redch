require 'rest_client'

module Redch::SOS
  module Client

    class Resource
      attr_reader :id
      attr_accessor :params, :headers

      def initialize(options = {})
        @params = options
        @headers = {
          content_type: "application/gml+xml",
          accept: "application/gml+xml"
        }
      end

      def base_uri
        URI
      end

      def http_post(sos_resource, payload = nil, &block)
        resource = RestClient::Resource.new(base_uri + sos_resource)
        response = resource.post(payload, headers)
        yield response if block_given?
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