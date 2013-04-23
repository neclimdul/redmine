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

%w{ libmagickcore-dev libmagickwand-dev imagemagick }.each do |package_name|
  package package_name do
    action :install
  end
end

gem_package 'bundler' do
  action :install
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
when "mysql"
  include_recipe "mysql::client"
  execute "mysql-create-redmine-db" do
    command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" mysql < #{node['mysql']['conf_dir']}/db_create_mysql.sql"
    action :nothing
  end
  template "#{node['mysql']['conf_dir']}/db_create_mysql.sql" do
    source "db_create_mysql.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, "execute[mysql-create-redmine-db]", :immediately
  end
when "postgresql"
  include_recipe "postgresql::client"
when "sqlite"
  include_recipe "sqlite"
  gem_package "sqlite3-ruby"
  file "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/db/production.db" do
    owner node[:apache][:user]
    group node[:apache][:user]
    mode "0644"
  end
when "sqlserver"
  include_recipe "sqlserver::client"
end

template "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  variables :database_server => node[:redmine][:db][:hostname]
  mode "0664"
end

execute "bundle install --without development test" do
  cwd "#{node[:redmine][:basedir]}/redmine-#{node[:redmine][:version]}"
end

execute "rake generate_secret_token" do
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
  server_name node[:redmine][:server_name]
  server_aliases node[:redmine][:server_aliases]
  rails_env "production"
end
