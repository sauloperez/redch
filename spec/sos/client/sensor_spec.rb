require 'spec_helper'

describe Redch::SOS::Client::Sensor do
  subject { Redch::SOS::Client::Sensor }

  let(:id) { 11 }
  let(:data) {
    {
      id: id,
      sensor_type: "in-situ",
      observation_type: 'http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement',
      foi_type: 'http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint',
      observable_prop_name: 'Photovoltaics',
      observable_prop: 'http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics'
    }
  }

  before do
    Redch::SOS::Client.configure do |config|
      config.namespace = 'http://www.redch.org/'
      config.intended_app = 'energy'
    end
  end

  its(:resource) { should be_kind_of(String) }
  its(:base_uri) { should_not be_nil }

  describe '#create' do
    let(:sensor) { subject.new }
    let(:body) {
      "<sosREST:Sensor><sosREST:link rel='foo.com/self' href='foo.com/sensor/#{id}' /><sosREST:link rel='foo.com' href='foo.com' /></sosREST:Sensor>"
    }

    before do
      stub_request(:post, "http://localhost:8080/webapp/sos/rest/sensors").
               with(:body => "<sosREST:Sensor service=\"SOS\" version=\"2.0.0\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:sml=\"http://www.opengis.net/sensorML/1.0.1\" xmlns:sosREST=\"http://www.opengis.net/sosREST/1.0\" xmlns:swe=\"http://www.opengis.net/swe/1.0.1\" xmlns:swes=\"http://www.opengis.net/swes/2.0\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.opengis.net/sos/2.0 http://schemas.opengis.net/sos/2.0/sosInsertSensor.xsd   http://www.opengis.net/swes/2.0 http://schemas.opengis.net/swes/2.0/swes.xsd\"><sml:System><sml:identification><sml:IdentifierList><sml:identifier name=\"uniqueID\"><sml:Term definition=\"urn:org:def:identifier:OGC:1:0:uniqueID\"><sml:value>11</sml:value></sml:Term></sml:identifier></sml:IdentifierList></sml:identification><sml:classification><sml:ClassifierList><sml:classifier name=\"intendedApplication\"><sml:Term definition=\"urn:org:def:identifier:OGC:1:0:application\"><sml:value>energy</sml:value></sml:Term></sml:classifier><sml:classifier name=\"sensorType\"><sml:Term definition=\"urn:org:def:identifier:OGC:1:0:sensorType\"><sml:value>in-situ</sml:value></sml:Term></sml:classifier></sml:ClassifierList></sml:classification><sml:validTime><gml:timePeriod><gml:beginPosition>2014-02-09</gml:beginPosition><gml:endPosition></gml:endPosition></gml:timePeriod></sml:validTime><sml:capabilities name=\"InsertionMetadata\"><swe:SimpleDataRecord><swe:field name=\"sos:ObservationType\"><swe:Text><swe:value>http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement</swe:value></swe:Text></swe:field><swe:field name=\"sos:FeatureOfInterestType\"><swe:Text><swe:value>http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint</swe:value></swe:Text></swe:field></swe:SimpleDataRecord></sml:capabilities><sml:inputs><sml:InputList><sml:input name=\"Photovoltaics\"><swe:ObservableProperty definition=\"http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics\"></swe:ObservableProperty></sml:input></sml:InputList></sml:inputs><sml:outputs><sml:OutputList><sml:output name=\"Photovoltaics\"><swe:Quantity definition=\"http://sweet.jpl.nasa.gov/2.3/phenEnergy.owl#Photovoltaics\"><swe:uom code=\"mm\"></swe:uom></swe:Quantity></sml:output></sml:OutputList></sml:outputs></sml:System></sosREST:Sensor>",
                    :headers => {'Accept'=>'application/gml+xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'2284', 'Content-Type'=>'application/gml+xml', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => body, :headers => {})
    end

    it 'assigns the sensor id' do
      expect(sensor).to receive(:current_date).and_return('2014-02-09')
      sensor.create(data)
      expect(sensor.id).to eq id
    end
  end
end
