require 'spec_helper'

describe Redch::SOS::Client::Templates do
  let(:dummy) { DummyClass.new }
  let(:data) { {name: 'test'} }
  let(:dummy_folder) { "/dummy_template_folder" }
  let(:dummy_extension) { "dum" }

  before :all do
    class DummyClass
      include Redch::SOS::Client::Templates
    end

    mock_template_file(:hello, "test Hello World!")
    mock_template_file(:test_data, "name = name")
  end

  after :all do
    delete_template_file(:hello)
    delete_template_file(:test_data)
  end

  it 'has a default template folder' do
    expect(dummy.settings.templates_folder).to eq "/Users/Pau/Sites/pfc-sources/redch/lib/redch/sos/client/templates"
  end

  it 'sets the template folder' do
    dummy.settings.templates_folder = dummy_folder
    expect(dummy.settings.templates_folder).to eq dummy_folder
  end

  it 'has a default template extension' do
    expect(dummy.settings.extension).to eq "slim"
  end

  it 'sets the template extension' do
    dummy.settings.extension = dummy_extension
    expect(dummy.settings.extension).to eq dummy_extension
  end

  it 'looks up templates in templates directory' do
    expect(dummy.render :hello).to eq "<test>Hello World!</test>"
  end

  it 'the template name must be a symbol or a string' do
    expect { dummy.render ['hello'] }.to raise_error ArgumentError
  end

  it 'raises if template not found' do
    expect { dummy.render :not_found }.to raise_error Errno::ENOENT
  end

  it 'accepts data to be rendered' do
    expect(dummy.render(:test_data, data)).to eq "<name>test</name>"
  end

  it 'raises if passed in data is not a Hash' do
    expect { dummy.render(:test_data, 'data') }.to raise_error ArgumentError
  end
end