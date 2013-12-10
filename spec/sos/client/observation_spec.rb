require 'spec_helper'

describe Redch::SOS::Client::Observation do
  before do
    Redch::SOS::Client.configure do |config|
      config.namespace = 'http://www.redch.org/'
      config.intended_app = 'bar'
    end
  end

  subject { Redch::SOS::Client::Observation }

  its(:resource) { should be_kind_of(String) }
  its(:base_uri) { should_not be_nil }

  describe '#create' do
    let(:observation) { subject.new }

    before do
      stub_request(:post, "http://localhost:8080/webapp/sos/rest/observations").
         with(:body => {"featureOfInterest"=>"http://www.redch.org/featureOfInterest/23", "observedProperty"=>"http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel", "offering"=>"http://www.redch.org/offering/23", "phenomenonTime"=>"2013-01-01T00:00:00+01:00", "result"=>"22", "resultTime"=>"2013-01-01T00:00:00+01:00", "samplingPoint"=>"1 2", "sensor"=>"23"},
              :headers => {'Accept'=>'application/gml+xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'347', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

      observation.create(
        sensor_id: "23",
        location: [1,2],
        observed_prop: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
        result: 22,
        time: Time.new(2013)
      )
    end

    it "should assign the observation id" do
      expect(observation.id).to be_kind_of(String)
    end
  end
end
