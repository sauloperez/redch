require 'spec_helper'

describe Redch::Config do
  let(:config) { Hashr.new('sos' => { 'a' => 'test' }) }

  describe '#load' do
    it 'returns a Hashr instance' do
      expect(Redch::Config.load).to be_kind_of(Hashr)
    end

    it 'returns Hashr instances on subkeys' do
      Redch::Config.save(config)
      config = Redch::Config.load
      pp config
      expect(config.sos).to be_kind_of(Hashr)
    end
  end

  describe '#save', :save => true do
    it 'stores the passed configuration' do
      Redch::Config.save(config)
      expect(Redch::Config.load).to eq(config)
    end

    it 'overwrites the values of existing keys' do
      Redch::Config.save(config)
      config.sos.a = 'new_test'
      Redch::Config.save(config)
      expect(Redch::Config.load).to eq(config)
    end
  end
end