require 'spec_helper'

describe Redch::Config do
  let(:config) { Hashr.new('sos' => { 'a' => 'test' }) }
  let(:filename) { Redch::Config.filename }

  describe '#load' do
    it 'returns a Hashr instance' do
      Redch::Config.save(config)
      expect(Redch::Config.load).to be_kind_of(Hashr)
    end

    it "raise if file doesn't exist" do
      allow(File).to receive(:open).with(filename, 'r').and_raise(Errno::ENOENT)
      expect { Redch::Config.load }.to raise_error(StandardError)
    end
  end

  describe '#save', :save => true do
    before do
      allow(File).to receive(:write).with(config.to_hash.to_yaml)
      allow(YAML).to receive(:load_file).and_return(config)
    end

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
