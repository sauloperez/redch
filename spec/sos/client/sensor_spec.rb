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
    let(:id) { 11 }
    before {
      stub_request(:post, "http://localhost:8080/webapp/sos/rest/sensors").
         with(:body => {"beginPosition"=>"2013-12-10", "featureOfInterest"=>"http://www.redch.org/featureOfInterest/11", "featureOfInterestID"=>"http://www.redch.org/featureOfInterest/11", "featureOfInterestType"=>"http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint", "intendedApplication"=>"energy", "observableProperty"=>"http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics", "observablePropertyName"=>"Photovoltaics", "observationType"=>"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement", "sensorType"=>"in-situ", "uniqueID"=>"11"},
              :headers => {'Accept'=>'application/gml+xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'565', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

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
