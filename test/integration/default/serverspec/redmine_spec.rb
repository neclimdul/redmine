require 'spec_helper'

# apache service
describe service('apache2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command("/opt/chef/embedded/bin/bundle exec rake -T redmine:plugins:migrate RAILS_ENV='production'") do
  let(:path) { '/srv/redmine' }
#  it { should return_exit_status 0 }
#  it { should return_stdout 'rake redmine:plugins:migrate  # Migrates installed plugins' }
end