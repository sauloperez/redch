require 'spec_helper'

describe Redch::SOS::Client do

  extend Redch::Helpers

  before :each do
    @sos_client = Redch::SOS::Client.new
  end

  describe "#register_device", :register_device => true do
    it "takes an id and registers the device in the SOS server" do
      id = Time.now.getutc.to_i.to_s
      expect(@sos_client.register_device(id)).to eq(id)
    end
  end

  describe "#post_sensor", :post_sensor => true do

    let(:sensor_profile) { {
      uniqueID: random_MAC_address,
      intendedApplication: 'energy',
      sensorType: 'in-situ',
      beginPosition: '2009-01-15',
      endPosition: '2009-01-20',
      featureOfInterestID: 'http://www.52north.org/test/featureOfInterest/9',
      observationType: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
      featureOfInterestType: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint'
    } }

    context "when the sensor has not been registered yet" do
      it "returns the sensor assigned id" do
        response = @sos_client.post_sensor sensor_profile
        expect(response).to be_kind_of(String)
        expect(response).to_not be_empty
      end
    end

    context "when the sensor has already been registered" do
      it "raises" do
        @sos_client.post_sensor sensor_profile
        expect { @sos_client.post_sensor sensor_profile }.to raise_error Redch::SOS::Error
      end
    end
  end

  describe "#post_observation", :post_observation => true do

    let(:sensor_id) { random_MAC_address }
    let(:sensor_profile) { {
      uniqueID: sensor_id,
      intendedApplication: 'energy',
      sensorType: 'in-situ',
      beginPosition: '2009-01-15',
      endPosition: '2009-01-20',
      featureOfInterestID: 'http://www.52north.org/test/featureOfInterest/9',
      observationType: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
      featureOfInterestType: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint'
    } }

    let(:observation) { {
      sensor: sensor_id,
      observedProperty: 'urn:ogc:def:property:OGC:1.0:precipitation',
      featureOfInterest: 'http://www.52north.org/test/featureOfInterest/9',
      result: rand.round(2),
      timePosition: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
      offering: "http://www.example.org/offering/#{sensor_id}/observations"
    } }

    context "when the sensor is registered" do
      it "returns an array of URIs to the supported observation operations" do
        @sos_client.post_sensor sensor_profile
        response = @sos_client.post_observation observation

        expect(response).to be_kind_of(Array)
        expect(response).to_not be_empty
      end
    end

    context "when the sensor it's not registered" do
      it "raises" do
        observation.merge({
          sensor: random_MAC_address,
          result: rand.round(2),
          timePosition: Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z").to_s,
          offering: "http://www.example.org/offering/#{sensor_id}/observations"
        })

        expect { @sos_client.post_observation observation }.to raise_error
      end
    end   
  end
end
