require 'spec_helper'

describe Redch::SOS::Client::Sensor do

  let(:sensor) {
    Redch::SOS::Client::Sensor.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  it 'has a default base_uri' do
    expect(sensor.base_uri).to eq 'http://localhost:8080/webapp/sos/'
  end

  describe '#new' do
    it "takes a Hash parameter" do
      expect(sensor.params).to be_kind_of(Hash)
    end

    it "requires the 'namespace' parameter" do
      expect(sensor.params[:namespace]).to eq 'http://www.redch.org/'
    end

    it "requires the 'intended_app' parameter" do
      expect(sensor.params[:intended_app]).to eq 'energy'
    end
  end

  describe '#create' do
    let(:id) { Time.now.getutc.to_i }
    let(:sensor_id) {
      sensor.create(id)
    }

    it "returns the sensor id" do
      expect(sensor_id).to eq id
    end
  end
end
