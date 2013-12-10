require 'spec_helper'

describe Redch::SOS::Client::Resource do
  subject {
    Redch::SOS::Client::Resource.new(
      namespace: 'http://www.redch.org/',
      intended_app: 'energy'
    )
  }

  let(:foo) { Foo.new }
  let(:path) { '/foo' }

  # Set up a new resource to test with
  before(:all) {
    class Foo < Redch::SOS::Client::Resource
      resource '/foo'
    end
  }

  its(:base_uri) { should eq 'http://localhost:8080/webapp/sos/rest' }

  describe '#new' do
    its(:params) { should be_kind_of(Hash) }
    its(:params) { should include :namespace }
    its(:params) { should include :intended_app }
  end

  describe '#http_post' do
    let(:payload) { 'foo=bar' }

    before {
      stub_request(:post, "http://localhost:8080/webapp/sos/rest/foo").
        with(body: payload).
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
        called = false
        foo.http_post(payload) { called = true }
        expect(called).to be true
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
