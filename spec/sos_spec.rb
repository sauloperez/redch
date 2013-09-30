require 'spec_helper'

RSpec.configure do |c|
  c.include Redch::Helpers
end

describe Redch::SOS::Client do
  before :each do
    @sos_client = Redch::SOS::Client.new
  end

  describe "#new" do
    it "takes no parameters and returns a Redch::SOS::Client object" do
      @sos_client.should be_an_instance_of Redch::SOS::Client
    end
  end

  describe "#post_sensor", :post_sensor => true do
    it "should return an array of links to the supported sensor operations" do
      sensor_profile = {
        uniqueID: get_MAC_address,
        longName: 'OSIRIS weather station 123 on top of the IfGI',
        shortName: 'OSIRIS Weather Station 123',
        intendedApplication: 'weather',
        sensorType: 'in-situ',
        beginPosition: '2009-01-15',
        endPosition: '2009-01-20',
        featureOfInterestID: 'http://www.52north.org/test/featureOfInterest/9',
        organizationName: 'CREAF',
        email: 'creaf@creaf.cat',
        position: { x: '2592308.332', y: '5659592.542', z: '5659592.542'},
        observationType: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
        featureOfInterestType: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint'
      }

      response = @sos_client.post_sensor sensor_profile

      response.should be_kind_of(Array)
      response.should_not be_empty
    end
  end

  describe "#post_observation", :post_observation => true do
    it "should return an array of links to the the supported observation operations" do
      response = @sos_client.post_observation observation

      response.should be_kind_of(Array)
      response.should_not be_empty
    end
  end
end
