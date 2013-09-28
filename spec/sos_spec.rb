require 'spec_helper'

describe Redch::SOS::Client do
  before :each do
    @sos_client = Redch::SOS::Client.new
  end

  describe "#new" do
    it "takes no parameters and returns a Redch::SOS::Client object" do
      @sos_client.should be_an_instance_of Redch::SOS::Client
    end
  end

  describe "#get_capabilities" do
    it "returns a Hash containing the list of capabilities" do
      @sos_client.get_capabilities.should be_kind_of Hash
    end
  end

  describe "#get_features" do
    it "returns a Hash containing the list of features" do
      @sos_client.get_features.should be_kind_of Hash
    end
  end
end
