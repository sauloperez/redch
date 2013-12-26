require_relative '../lib/redch/helpers.rb'
require_relative '../lib/redch/setup.rb'
require_relative '../lib/redch/sos.rb'
require_relative '../lib/redch/config.rb'
require_relative '../lib/redch/loop.rb'
require_relative '../lib/redch/simulate.rb'
require_relative '../lib/redch/sos/client/templates.rb'

require 'webmock/rspec'
require 'yaml'

RSpec.configure do |config|
  config.include Redch::Helpers

  config.expect_with :rspec do |c|
    # disable the 'should' syntax
    c.syntax = :expect
  end
end
