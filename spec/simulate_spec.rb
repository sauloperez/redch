require 'spec_helper'

describe Redch::Simulate do

  let(:sos_client) { double 'sos_client' }
  let(:device_id) { Redch::Config.load.sos.device_id }
  let(:location) { Redch::Config.load.sos.location }

  describe "#run" do

    before {
      delete_config_file
      id = Time.now.getutc.to_i.to_s
      sos_client
        .should_receive(:register_device)
        .with(id)
        .and_return(id)

      setup = Redch::Setup.new
      setup.sos_client= sos_client
      setup.location= [41.82749, 1.60584]
      setup.device_id= id
      setup.run
    }

    it "sends generated random observations to SOS" do
      sos_client.should_receive(:post_observation)        

      simulate = Redch::Simulate.new(device_id, location)
      simulate.sos_client= sos_client

      executed = false
      simulate.run do
        executed = true
        simulate.stop
      end

      expect(executed).to eq(true)
    end

    it "raises if any of location or device_id are not set" do
      expect {
        simulate = Redch::Simulate.new(device_id)
      }.to raise_error(ArgumentError)

      expect {
        simulate = Redch::Simulate.new(location)
      }.to raise_error(ArgumentError)

      expect {
        simulate = Redch::Simulate.new
      }.to raise_error(ArgumentError)
    end
  end  

  describe "#generate_value" do
    let(:simulate) { Redch::Simulate.new(device_id, location) }

    it "generates a random sample" do
      expect(simulate.generate_value).to be_kind_of(Float)
    end
  end
end