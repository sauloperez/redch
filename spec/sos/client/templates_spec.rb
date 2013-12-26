require 'spec_helper'

describe Redch::SOS::Client::Templates do
  class DummyClass; end

  before :all do
    @dummy = DummyClass.new
    @dummy.extend Redch::SOS::Client::Templates
  end

  it 'looks up templates in views directory' do
    expect(@dummy.render :hello).to eq "<test>Hello World!</test>"
  end

  it 'the template name must be a symbol or a string' do
    expect { @dummy.render ['hello'] }.to raise_error ArgumentError
  end
end