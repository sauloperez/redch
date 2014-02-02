require 'spec_helper'

describe Redch::SOS::Client do
  subject { Redch::SOS::Client }

  before { subject.configure }

  let(:intended_app) { 'weather' }
  let(:namespace) { 'weather.cat' }

  its(:configuration) { should respond_to :namespace }
  its(:configuration) { should respond_to :namespace= }
  its(:configuration) { should respond_to :intended_app }
  its(:configuration) { should respond_to :intended_app= }

  context "when a block is provided" do
    let(:configuration) { subject.configuration }

    it "returns the configured namespace" do
      subject.configure { |config| config.namespace = namespace }
      expect(configuration.namespace).to eq namespace
    end

    it "returns the configured value" do
      subject.configure { |config| config.intended_app = intended_app }
      expect(configuration.intended_app).to eq intended_app
    end
  end

end
