require 'spec_helper'

describe Redch::Simulate do
  before :each do
    @simulate = Redch::Simulate.new
  end

  describe "#new" do
    it "takes three optional parameters and returns a Redch::Simulate instance" do
      expect(@simulate).to be_an_instance_of Redch::Simulate
    end
  end  

  describe "#generate_value" do
    it "generates a random sample" do
      expect(@simulate.generate_value).to be_kind_of(Float)
    end
  end
end