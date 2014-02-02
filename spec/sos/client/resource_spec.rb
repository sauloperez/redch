require 'spec_helper'

describe Redch::SOS::Client::Resource do
  before do
    Redch::SOS::Client.configure do |config|
      config.namespace = 'foo'
      config.intended_app = 'bar'
    end
  end

  let(:foo) { Foo.new }
  let(:path) { '/foo' }

  # Set up a new resource to test with
  before(:all) do
    class Foo < Redch::SOS::Client::Resource
      resource '/foo'
    end
  end

  its(:base_uri) { should eq 'http://localhost:8080/webapp/sos/rest' }

  describe '#http_post' do
    let(:data) { { value: 'blalala' } }
    let(:headers) { { content_type: "application/gml+xml", accept: "application/gml+xml" } }
    let(:rendered_template) { "<post>#{data[:value]}</post>" }
    let(:response) { double }

    before do
      mock_template_file(:post_foo, "post = value")

      stub_request(:post, "http://localhost:8080/webapp/sos/rest/foo").
               with(:body => rendered_template,
                    :headers => {'Accept'=>'application/gml+xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'20', 'Content-Type'=>'application/gml+xml', 'User-Agent'=>'Ruby'})
    end

    after :all do
      delete_template_file(:post_foo)
    end

    it 'sends the payload' do
      allow(response).to receive(:body).and_return('')
      expect_any_instance_of(RestClient::Resource).to receive(:post).with(rendered_template, headers).and_return(response)

      foo.http_post(data)
    end

    it 'uses a template depending on the HTTP method and resource name' do
      expect(foo).to receive(:render).with(:post_foo, data).and_return(rendered_template)
      foo.http_post(data)
    end

    context 'when an implicit block is passed in' do
      it 'calls it' do
        called = false
        foo.http_post(data) { called = true }
        expect(called).to be true
      end

      it 'yields the HTTP response body' do
        body = nil
        foo.http_post(data) do |b|
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

      it 'raises' do
        expect{
          foo.http_post(data)
        }.to raise_error(Redch::SOS::Client::Error)
      end
    end
  end
end
