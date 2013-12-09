require 'spec_helper'

describe Redch::SOS::Client::Resource do
  let(:resource) {
    Redch::SOS::Client::Resource.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  it 'has a default base_uri' do
    expect(resource.base_uri).to eq 'http://localhost:8080/webapp/sos'
  end

  describe '#new' do
    it "takes a Hash parameter" do
      expect(resource.params).to be_kind_of(Hash)
    end

    it "requires the 'namespace' parameter" do
      expect(resource.params[:namespace]).to eq 'http://www.redch.org/'
    end

    it "requires the 'intended_app' parameter" do
      expect(resource.params[:intended_app]).to eq 'energy'
    end
  end

  describe '#http_post' do
    let(:payload) { 'foo=bar' }
    let(:sos_resource) { '/foo' }

    it "issues a request to a resource" do
      resource.http_post(sos_resource)
      expect(sos_resource).to be_kind_of(String)      
    end

    it "issues an HTTP POST request" do
      stub_request(:post, "http://localhost:8080/webapp/sos#{sos_resource}")
      resource.http_post(sos_resource)
    end

    it "accepts a payload" do
      resource.http_post(sos_resource, payload)
      expect(payload).to_not be_nil
    end

    context "when an implicit block is passed in" do
      it "calls it" do
        resource.http_post(sos_resource, payload) {}
      end

      it "yields the HTTP response" do
        response = nil
        resource.http_post(sos_resource, payload) do |r|
          response = r
        end
        expect(response).to_not be_nil
      end
    end

  end
end