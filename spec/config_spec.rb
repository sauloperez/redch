require 'spec_helper'

describe Redch::Config do
  let(:config) { { 'sos' => { 'a' => 'test' } } }
  let(:hashr_config) { Hashr.new(config) }
  let(:yaml_config) { hashr_config.to_hash.to_yaml }

  let(:file) { double 'file' }
  let(:filename) { Redch::Config.filename }

  before do
    allow(YAML).to receive(:load_file).and_return(config)
  end

  describe '#load' do
    before do
      allow(File).to receive(:write).with(config.to_yaml)
    end

    it 'returns a Hashr instance' do
      allow(File).to receive(:open).with(filename, 'r')
      expect(Redch::Config.load).to be_kind_of(Hashr)
    end

    it 'raises if file does not exist' do
      allow(File).to receive(:open).with(filename, 'r').and_raise(Errno::ENOENT)
      expect { Redch::Config.load }.to raise_error(Errno::ENOENT)
    end
  end

  describe '#save', :save => true do
    before do
      allow(File).to receive(:open).with(filename, 'w').and_yield(file)
    end

    it 'stores the passed configuration' do
      expect(file).to receive(:write).with(yaml_config)
      Redch::Config.save(hashr_config)
    end

    it 'overwrites the values of existing keys' do
      expect(file).to receive(:write).with(config.to_yaml)

      Redch::Config.save(config)
      config['sos']['a'] = 'new_test'

      expect(file).to receive(:write).with(config.to_yaml)

      Redch::Config.save(config)
    end
  end
end
