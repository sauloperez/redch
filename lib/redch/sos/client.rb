require 'client/helpers'
require 'client/resource'
require 'client/sensor'
require 'client/observation'
require 'client/error'

module Redch
  module SOS

    module Client
      VERSION = '0.1.0'
      URI = 'http://localhost:8080/webapp/sos/rest'

      class << self
        attr_accessor :configuration
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration) if block_given?
      end

      # Any default value must be set in its initialization
      class Configuration
        attr_accessor :namespace, :intended_app
      end
    end

  end
end
