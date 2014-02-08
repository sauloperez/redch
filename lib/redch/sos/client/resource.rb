require 'client'
require 'nori'
require 'rest_client'
require_relative 'templates'

module Redch::SOS
  module Client

    class Resource
      include Helpers
      include Templates

      attr_reader :id, :headers

      def initialize(options = {})
        @parser = Nori.new
        header :accept, 'application/gml+xml'
        header :content_type, 'application/gml+xml'
      end

      def self.resource(path = nil)
        @@resource_paths ||= {}
        return @@resource_paths[self] if path.nil?
        @@resource_paths[self] = path
      end

      def header(name, value)
        @headers ||= {}
        @headers[name] = value
      end

      def self.base_uri
        URI
      end

      def base_uri
        URI
      end

      def resource_name
        @@resource_paths[self.class]
      end

      # Returns a symbol compound of HTTP method and resource name
      #
      # @param [Symbol] instance method name with the form `http_<HTTP_method>`
      # @return [Symbol] <HTTP_method>_<resource_name>
      def template_name(method)
        http_method = method.to_s.match(/([^_]+)$/)[0]
        rest_name = resource_name.to_s.match(/([^\/]+)$/)[0]

        "#{http_method}_#{rest_name}".to_sym
      end

      def http_post(data, &block)
        http_request do
          path = base_uri + resource_name
          rest_resource = RestClient::Resource.new(path)

          template = template_name(__method__)
          payload = render(template, data)

          response = rest_resource.post(payload, headers)
          parsed_body = @parser.parse response.body

          yield parsed_body if block_given?
        end
      end

      protected

      def http_request
        yield
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
