require 'spec_helper'

describe Redch::Setup do
  let(:device_id) { 1 }
  let(:location) { [1.2, 2.1] }
  let(:required_fields) { [:id, :sensor_type, :observation_type, :foi_type, :observable_prop_name, :observable_prop] }

  describe '#new' do
    it 'configures the SOS client' do
      expect(Redch::SOS::Client).to receive(:configure)
      Redch::Setup.new
    end

    it 'instanciates a SOS::Client Sensor' do
      expect(Redch::SOS::Client::Sensor).to receive(:new)
      Redch::Setup.new
    end
  end

  describe '#sensor' do
    it 'builds up a sensor payload' do
      sensor = subject.sensor(device_id)
      expect([sensor.keys]).to include required_fields
    end
  end

  describe '#register_device' do
    it 'requests to store the device in the SOS' do
      expect_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create)
      subject.register_device(device_id, location)
    end
  end

  describe '#done?' do
    it 'returns true if the configuration can be loaded' do
      allow(Redch::Config).to receive(:load)
      expect(subject.done?).to be true
    end

    it 'returns false otherwise' do
      allow(Redch::Config).to receive(:load).and_raise(StandardError)
      expect(subject.done?).to be false
    end
  end

  describe '#run' do
    context 'when there\'s no stored configuration' do
      let(:config) { Hashr.new }

      before do
        allow(Redch::Config).to receive(:load).and_raise(StandardError.new)
      end

      it 'raises if either device_id or location are not set' do
        expect { subject.run }.to raise_error StandardError
      end

      context 'when all params are set' do
        before :each do
          subject.device_id= device_id
          subject.location= location
        end

        it 'requests to create the sensor in the SOS' do
          expect_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create)
          subject.run
        end

        it 'stores the configuration on successful request' do
          allow_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create).and_return(device_id)
          expect(Redch::Config).to receive(:save).with(subject.config)
          subject.run
        end

        context 'when the sensor can\'t be created' do
          before do
            allow_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create).and_raise
          end

          it 'outputs the error message' do
            expect_any_instance_of(StandardError).to receive(:message)
            subject.run
          end

          it 'does not store the configuration' do
            expect(Redch::Config).to_not receive(:save)
            subject.run
          end
        end

      end
    end

    context 'when the stored configuration is not empty' do
      let(:config) { Hashr.new(sos: { location: location, device_id: device_id }) }

      before do
        allow(Redch::Config).to receive(:load).and_return(config)
      end

      it 'loads the device_id from it' do
        expect(device_id).to eq config.sos.device_id
        subject.run
      end

      it 'loads the location from it' do
        expect(location).to eq config.sos.location
        subject.run
      end

      it 'does not request to create the sensor in the SOS again' do
        expect_any_instance_of(Redch::SOS::Client::Sensor).to_not receive(:create).and_return(config.sos.device_id)
        subject.run
      end
    end
  end

end
