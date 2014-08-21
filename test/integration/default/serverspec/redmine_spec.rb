require 'spec_helper'
require 'net/http'

describe port(80) do
  it { should be_listening }
end
describe port(443) do
  it { should be_listening }
end

describe "Redmine redirect" do
  uri = URI('http://127.0.0.1')
  http = Net::HTTP.new(uri.host, uri.port)

  response = http.get(uri.request_uri)
  context response.code do
    it { should eq '301' }
  end
  context response["Location"] do
    it { should eq 'https://redmine.vagrantup.com/' }
  end
end

describe "Redmine redirect" do
  uri = URI('https://127.0.0.1')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl   = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  response = http.get(uri.request_uri)
  context response.code do
    it { should eq '200' }
  end
end
