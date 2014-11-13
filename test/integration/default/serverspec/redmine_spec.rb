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
#   context response["Location"] do
#     it { should eq 'https://redmine.vagrantup.com/' }
#   end
end

# Basic response verification
describe "Redmine application" do
  uri = URI('https://127.0.0.1')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl   = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  response = http.get(uri.request_uri)
  context response.code do
    it { should eq '200' }
  end
end

describe file("/etc/apache2/sites-enabled/redmine.conf") do
  it { should be_file }
  its(:content) { should match /ServerName test/ }
end

describe file("/srv/redmine/shared/files") do
  it { should be_directory }
  it { should be_owned_by "www-data" }
end
describe file("/srv/redmine/current/files") do
  it { should be_linked_to '/srv/redmine/shared/files' }
end

describe file("/srv/redmine/shared/plugins") do
  it { should be_directory }
  it { should be_owned_by "www-data" }
end
describe file("/srv/redmine/current/plugins") do
  it { should be_linked_to '/srv/redmine/shared/plugins' }
end

describe file("/srv/redmine/shared/logs") do
  it { should be_directory }
  it { should be_owned_by "www-data" }
end
describe file("/srv/redmine/current/logs") do
  it { should be_linked_to '/srv/redmine/shared/logs' }
end

describe file("/srv/redmine/current/tmp") do
  it { should be_directory }
  it { should be_owned_by "www-data" }
end
describe file("/srv/redmine/current/public/plugin_assets") do
  it { should be_directory }
  it { should be_owned_by "www-data" }
end
