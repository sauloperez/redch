require 'spec_helper'

describe Redch::SOS::Client do
  subject { Redch::SOS::Client }
  before { subject.configure }

  its(:configuration) { should respond_to :namespace }
  its(:configuration) { should respond_to :namespace= }
  its(:configuration) { should respond_to :intended_app }
  its(:configuration) { should respond_to :intended_app= }

  context "when a block is provided" do
    let(:configuration) { subject.configuration }

    context "when namespace is specified" do
      let(:namespace) { 'weather.cat' }

      before do
        subject.configure do |config|
          config.namespace = namespace
        end
      end

      it "returns the configured value" do
        expect(configuration.namespace).to eq namespace
      end
    end

    context "when intended_app is specified" do
      let(:intended_app) { 'weather' }

      before do
        subject.configure do |config|
          config.intended_app = intended_app
        end
      end

      it "returns the configured value" do
        expect(configuration.intended_app).to eq intended_app
      end
    end

  end
end
