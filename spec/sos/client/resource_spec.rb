require 'spec_helper'

describe Redch::SOS::Client::Resource do
  let(:resource) {
    Redch::SOS::Client::Resource.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  it 'has a default base_uri' do
    expect(resource.base_uri).to eq 'http://localhost:8080/webapp/sos/rest'
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
    let(:foo) { Foo.new }
    let(:path) { '/foo' }

    before(:all) {
      # Set up a new resource
      class Foo < Redch::SOS::Client::Resource
        resource '/foo'
      end
      foo = Foo.new

      stub_request(:post, "http://localhost:8080/webapp/sos/rest/foo").
        to_return(:status => 200)
    }

    it "accepts a payload" do
      foo.http_post(payload)
      expect(payload).to_not be_nil
    end

    context "when an implicit block is passed in" do
      before { 
        stub_request(:post, "#{foo.base_uri}#{path}").
          with(body: payload).
          to_return(:status => 200)
      }

      it "calls it" do
        foo.http_post(payload) {}
      end

      it "yields the HTTP response body" do
        body = nil
        foo.http_post(payload) do |b|
          body = b
        end
        expect(body).to_not be_nil
      end
    end

    context "when there's an HTTP error" do
      before { 
        stub_request(:post, "#{foo.base_uri}#{path}").
          to_return(:status => 400)
      }

      it "raises" do 
        expect{ 
          foo.http_post(payload)
        }.to raise_error(Redch::SOS::Client::Error)
      end
    end
  end
end