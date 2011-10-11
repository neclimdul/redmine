#
# Author: Joshua Timberman <joshua@housepub.org>
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2008-2009, Joshua Timberman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "application::default"

gem_package 'i18n' do
  action :install
  version "0.4.2"
end

gem_package 'rack' do
  action :install
  version '1.1.0'
end
  
bash "install_redmine" do
  cwd "#{node[:redmine][:basedir]}"
  user "root"
  code <<-EOH
    wget http://rubyforge.org/frs/download.php/#{node[:redmine][:dl_id]}/redmine-#{node[:redmine][:version]}.tar.gz
    tar xf redmine-#{node[:redmine][:version]}.tar.gz
    chown -R #{node[:apache][:user]} redmine-#{node[:redmine][:version]}
  EOH
  not_if { ::File.exists?("#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/Rakefile") }
end

link "#{node[:redmine][:basedir]}/redmine" do
  to "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}"
end

case node[:redmine][:db][:type]
when "sqlite"
  include_recipe "sqlite"
  gem_package "sqlite3-ruby"
  
  file "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/db/production.db" do
    owner node[:apache][:user]
    group node[:apache][:user]
    mode "0644"
  end
when "mysql"
  include_recipe "mysql::client"
end

template "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  variables :database_server => node[:redmine][:db][:hostname]
  mode "0664"
end

execute "rake generate_session_store" do
  user node[:apache][:user]
  cwd "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}"
end

execute "rake db:migrate RAILS_ENV='production'" do
  user node[:apache][:user]
  cwd "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}"
  not_if { ::File.exists?("#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/db/schema.rb") }
end

web_app "redmine" do
  docroot "#{node[:redmine][:basedir]}/redmine/public"
  template "redmine.conf.erb"
  server_name "redmine.#{node[:domain]}"
  server_aliases [ "redmine", node[:hostname] ]
  rails_env "production"
end
