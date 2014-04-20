require 'spec_helper'

describe Redch::Simulate do
  let(:period) { 2 }
  let(:mean) { 0.1 }
  let(:dev) { 0.1 }

  let(:value) { 2.3 }
  let(:device_id) { 1 }
  let(:location) { [1.2, 2.1] }
  let(:required_fields) { [:sensor_id, :location, :observed_prop, :result, :time] }
  let(:loop) { double }

  before do
    allow(loop).to receive(:start).and_yield
    allow(Redch::Loop).to receive(:new).and_return(loop)
  end

  subject { Redch::Simulate.new(device_id, location) }

  it 'allows to set the mean' do
    subject.mean = mean
    expect(subject.mean).to eq mean
  end

  it 'allows to set the std deviation' do
    subject.dev = dev
    expect(subject.dev).to eq dev
  end

  it 'allows to set the period' do
    subject.period = period
    expect(subject.period).to eq period
  end

  describe '#new' do
    it 'requires a device_id and a location' do
      expect {
        Redch::Simulate.new
      }.to raise_error ArgumentError
    end

    it 'configures the SOS client' do
      expect(Redch::SOS::Client).to receive(:configure)
      Redch::Simulate.new(device_id, location)
    end

    it 'instanciates a SOS::Client Observation' do
      expect(Redch::SOS::Client::Observation).to receive(:new)
      Redch::Simulate.new(device_id, location)
    end

    it 'instanciates a Redch::Loop' do
      expect(Redch::Loop).to receive(:new)
      Redch::Simulate.new(device_id, location)
    end

    it 'sets the params default values' do
      expect(subject.mean).to_not be_nil
      expect(subject.dev).to_not be_nil
      expect(subject.period).to_not be_nil
    end
  end

  describe '#generate_value' do
    it 'requires a period, mean and std deviation' do
      expect {
        subject.generate_value
      }.to raise_error ArgumentError
    end

    it 'returns a positive integer' do
      v = subject.generate_value(mean, dev)
      expect(v).to be >= 0
    end
  end

  describe '#observation' do
    it 'builds up an observation payload' do
      observation = subject.observation(value)
      expect([observation.keys]).to include required_fields
    end
  end

  describe '#register_observation' do
    it 'requests to store the observation in the SOS' do
      expect_any_instance_of(Redch::SOS::Client::Observation).to receive(:create)
      subject.register_observation(value)
    end
  end

  describe '#run' do
    it 'registers observations in a indefinite loop' do
      expect_any_instance_of(Redch::SOS::Client::Observation).to receive(:create)
      expect(loop).to receive(:start)
      subject.run
    end

    it 'yields the generated value if a block is given' do
      expect_any_instance_of(Redch::SOS::Client::Observation).to receive(:create)

      value = nil
      subject.run do |v|
        value = v
      end
      expect(value).to_not be_nil
    end

    context 'when the observation can\'t be created' do
      before do
        allow_any_instance_of(Redch::SOS::Client::Observation).to receive(:create).and_raise
      end

      it 'outputs the error message' do
        allow(loop).to receive(:stop)
        expect_any_instance_of(StandardError).to receive(:message)
        subject.run
      end

      it 'stops the loop' do
        expect(loop).to receive(:stop)
        subject.run
      end
    end
  end
end
