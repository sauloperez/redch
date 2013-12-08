Dir[File.dirname(__FILE__) + '/sos/*.rb'].each do |file|
  require file
end

module Redch
  module SOS
    VERSION = '0.1.0'
    SOS_VERSION = '2.0'
  end
end
