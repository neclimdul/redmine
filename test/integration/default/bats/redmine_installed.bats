#!/usr/bin/env bats

load test_helper

@test "redmine source linked" {
  run find /srv/redmine
  assert_success
}

@test "redmine source in linked directory" {
  run find /srv/redmine/Gemfile
  assert_success
}

@test "bundle exists" {
  export PATH="/opt/chef/embedded/bin:$PATH"
  run which bundle
  assert_success
}

@test "Bundle install was run on redmine" {
  run find /srv/redmine/.bundle
  assert_success
}

@test "Bundle setup allows setup of plugins" {
  cd /srv/redmine
  export PATH="/opt/chef/embedded/bin:$PATH"
  export GEM_PATH="/opt/chef/embedded/lib/ruby/gems/1.9.1"
  run /opt/chef/embedded/bin/bundle exec rake -T redmine:email:receive_imap RAILS_ENV='production'
  assert_output "rake redmine:email:receive_imap  # Read emails from an IMAP server"
}

@test "Bundle setup allows setup of plugins" {
  cd /srv/redmine
  export PATH="/opt/chef/embedded/bin:$PATH"
  export GEM_PATH="/opt/chef/embedded/lib/ruby/gems/1.9.1"
  run /opt/chef/embedded/bin/bundle exec rake -T redmine:plugins:migrate RAILS_ENV='production'
  assert_output "rake redmine:plugins:migrate  # Migrates installed plugins"
}
