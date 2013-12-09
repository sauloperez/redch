require 'client/resource'
require 'client/sensor'
require 'client/observation'

# TODO Move requires deeper
require 'redch/error'
require 'rest_client'
require 'logger'
require 'nokogiri'
require 'nori'
require 'slim/logic_less'
require 'yaml'

module Redch
  module SOS

    module Client
      VERSION = '0.1.0'
      URI = 'http://localhost:8080/webapp/sos'
    end

  end
end
