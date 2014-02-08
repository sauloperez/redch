require 'spec_helper'

describe Redch::Setup do

  describe '#run' do
    let(:device_id) { 1 }
    let(:location) { [1.2, 2.1] }

    context 'when the stored configuration is empty' do
      let(:config) { Hashr.new }

      before do
        allow(Redch::Config).to receive(:load).and_raise(StandardError.new)
      end

      it 'raises if any of the params is not set' do
        expect { subject.run }.to raise_error StandardError
      end

      context 'when all params are set' do
        before :each do
          subject.device_id= device_id
          subject.location= location
        end

        it 'requests to create the sensor in the SOS' do
          expect_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create).and_return(device_id)
          subject.run
        end

        it 'stores the configuration on successful request' do
          expect_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create).and_return(device_id)
          expect(Redch::Config).to receive(:save).with(subject.config)
          subject.run
        end

        it 'does not store the configuration on unsuccessful request' do
          expect_any_instance_of(Redch::SOS::Client::Sensor).to receive(:create).and_raise
          expect(Redch::Config).to_not receive(:save)
          expect {
            subject.run
          }.to raise_error
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
