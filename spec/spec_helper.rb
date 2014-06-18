require_relative '../lib/redch/helpers.rb'
require_relative '../lib/redch/setup.rb'
require_relative '../lib/redch/sos.rb'
require_relative '../lib/redch/config.rb'
require_relative '../lib/redch/loop.rb'
require_relative '../lib/redch/simulate.rb'
require_relative '../lib/redch/sos/client/templates.rb'

require 'yaml'
require 'byebug'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include Redch::Helpers
  config.include Redch::SOS::Client::Templates

  config.expect_with :rspec do |c|
    # disable the 'should' syntax
    c.syntax = :expect
  end
end

def mock_template_file(name, content)
  filename = File.join(settings.templates_folder, "#{name.to_s}.#{settings.extension}")
  File.open(filename, 'w') do |file|
    file.puts content
  end
end

def delete_template_file(name)
  filename = File.join(settings.templates_folder, "#{name.to_s}.#{settings.extension}")
  File.delete(filename)
end
