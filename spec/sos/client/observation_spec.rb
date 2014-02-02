require 'spec_helper'

describe Redch::SOS::Client::Observation do
  subject { Redch::SOS::Client::Observation }

  let(:data) {
    {
      sensor_id: "23",
      location: [1,2],
      observed_prop: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
      result: 22,
      time: Time.new(2014)
    }
  }

  before do
    Redch::SOS::Client.configure do |config|
      config.namespace = 'http://www.redch.org/'
      config.intended_app = 'bar'
    end
  end

  its(:resource) { should be_kind_of(String) }
  its(:base_uri) { should_not be_nil }

  describe '#create' do
    let(:observation) { subject.new }
    let(:id) { 123 }
    let(:body) {
      "<sosREST:Observation><sosREST:link rel='foo.com' href='foo.com/observation/#{id}'>#{id}</sosREST:link></sosREST:Observation>"
    }

    before do
      stub_request(:post, "http://localhost:8080/webapp/sos/rest/observations").
               with(:body => "<sosREST:Observation service=\"SOS\" version=\"2.0.0\" xmlns:gml=\"http://www.opengis.net/gml/3.2\" xmlns:om=\"http://www.opengis.net/om/2.0\" xmlns:sams=\"http://www.opengis.net/samplingSpatial/2.0\" xmlns:sf=\"http://www.opengis.net/sampling/2.0\" xmlns:sosREST=\"http://www.opengis.net/sosREST/1.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><om:OM_Observation><om:phenomenonTime><gml:TimeInstant><gml:timePosition>2014-01-01T00:00:00+01:00</gml:timePosition></gml:TimeInstant></om:phenomenonTime><om:resultTime><gml:TimeInstant><gml:timePosition>2014-01-01T00:00:00+01:00</gml:timePosition></gml:TimeInstant></om:resultTime><om:procedure xlink:href=\"23\"></om:procedure><om:observedProperty xlink:href=\"http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel\"></om:observedProperty><om:featureOfInterest><sams:SF_SpatialSamplingFeature gml:id=\"ssf_test_feature_6\"><gml:identifier codeSpace=\"\">http://www.redch.org/featureOfInterest/23</gml:identifier><sf:type xlink:href=\"http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint\"></sf:type><sf:sampledFeature xlink:href=\"http://www.redch.org/featureOfInterest/23\"></sf:sampledFeature><sams:shape><gml:Point gml:id=\"SamplingPoint1\"><gml:pos srsName=\"http://www.opengis.net/def/crs/EPSG/0/4326\">1 2</gml:pos></gml:Point></sams:shape></sams:SF_SpatialSamplingFeature></om:featureOfInterest><om:result uom=\"urn:ogc:def:uom:OGC:m\" xsi:type=\"gml:MeasureType\">22</om:result></om:OM_Observation><sosREST:link href=\"http://www.redch.org/offering/23\" rel=\"http://www.opengis.net/sosREST/1.0/offering-get\" type=\"application/gml+xml\"></sosREST:link></sosREST:Observation>",
                    :headers => {'Accept'=>'application/gml+xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1674', 'Content-Type'=>'application/gml+xml', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => body, :headers => {})
    end

    it "assigns the observation id" do
      observation.create(data)
      expect(observation.id).to eq id
    end
  end
end
