require 'spec_helper'

describe Redch::SOS::Client::Observation do
  subject { Redch::SOS::Client::Observation }

  let(:observation) {
    Redch::SOS::Client::Observation.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  its(:resource) { should be_kind_of(String) }
  its(:base_uri) { should_not be_nil }

  describe '#create' do
    before {
      observation.create(
        sensor_id: Time.now.getutc.to_i.to_s,
        location: [1,2],
        observed_prop: 'http://purl.oclc.org/NET/ssnx/energy/ssn-energy#SolarPanel',
        result: 22,
        time: Time.now
      )
    }

    it "should assign the observation id" do
      expect(observation.id).to be_kind_of(String)
    end
  end
end
