require 'spec_helper'

describe Redch::SOS::Client::Sensor do
  subject { Redch::SOS::Client::Sensor }

  let(:sensor) {
    Redch::SOS::Client::Sensor.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  its(:resource) { should be_kind_of(String) }
  its(:base_uri) { should_not be_nil }

  describe '#create' do
    let(:id) { Time.now.getutc.to_i }
    before {
      sensor.create(
        id: id,
        sensor_type: "in-situ",
        observation_type: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
        foi_type: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint',
        observable_prop_name: 'Photovoltaics',
        observable_prop: 'http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics'
      )
    }

    it "should assign the sensor id" do
      expect(sensor.id).to eq id
    end
  end
end