require 'spec_helper'

describe Redch::SOS::Client::Templates do
  class DummyClass; end

  let(:data) { {name: 'test'} }

  before :all do
    @dummy = DummyClass.new
    @dummy.extend Redch::SOS::Client::Templates
  end

  it 'looks up templates in templates directory' do
    expect(@dummy.render :hello).to eq "<test>Hello World!</test>"
  end

  it 'the template name must be a symbol or a string' do
    expect { @dummy.render ['hello'] }.to raise_error ArgumentError
  end

  it 'raises if template not found' do
    expect { @dummy.render :not_found }.to raise_error Errno::ENOENT
  end

  it 'allows to pass data in' do
    expect(@dummy.render(:test_data, data)).to eq "<name>test</name>"
  end

  it 'raises if passed in data is not a Hash' do
    expect { @dummy.render(:test_data, 'data') }.to raise_error ArgumentError
  end
end