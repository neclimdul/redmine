#
# Author: Joshua Timberman <joshua@housepub.org>
# Author: James Gilliland (<neclimdul@gmail.com>)
# Cookbook Name:: redmine
# Recipe:: _source
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

%w{ libmagickcore-dev libmagickwand-dev imagemagick }.each do |package_name|
  package package_name do
    action :install
  end
end

gem_package 'bundler' do
  action :install
end

bash "install_redmine" do
  cwd node["redmine"]["basedir"]
  user "root"
  code <<-EOH
    wget http://www.redmine.org/releases/redmine-#{node['redmine']['version']}.tar.gz
    tar xf redmine-#{node["redmine"]["version"]}.tar.gz
    chown -R #{node["apache"]["user"]} redmine-#{node["redmine"]["version"]}
  EOH
  not_if { ::File.exists?("#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}/Rakefile") }
end

link "#{node["redmine"]["basedir"]}/redmine" do
  to "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}"
end

include_recipe node["redmine"]["db"]["server_recipe"] if !node["redmine"]["db"]["server_recipe"].empty?
include_recipe node["redmine"]["db"]["client_recipe"] if !node["redmine"]["db"]["client_recipe"].empty?

case node["redmine"]["db"]["type"]
when "mysql"
  execute "mysql-create-redmine-db" do
    command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" mysql < #{node['mysql']['conf_dir']}/db_create_mysql.sql"
    action :nothing
    notifies :restart, "service[apache2]", :immediately
  end
  template "#{node['mysql']['conf_dir']}/db_create_mysql.sql" do
    source "db_create_mysql.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, "execute[mysql-create-redmine-db]", :immediately
  end
when "sqlite"
  gem_package "sqlite3-ruby"
  file "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}/db/production.db" do
    owner node["apache"]["user"]
    group node["apache"]["user"]
    mode "0644"
  end
end

template "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  variables :database_server => node["redmine"]["db"]["hostname"]
  mode "0664"
end

directory "#{node["redmine"]["basedir"]}/plugin_assets" do
  action :create
  owner node["apache"]["user"]
  group node["apache"]["group"]
  mode "0755"
end

link "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}/public/plugin_assets" do
  to "#{node["redmine"]["basedir"]}/plugin_assets"
end

execute "redmine-bundle-install" do
  command "bundle install --path /srv/redmine/.bundle"
  user node["apache"]["user"]
  cwd "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}"
end

execute "redmine-create-secret-token" do
  command "bundle exec rake generate_secret_token"
  user node["apache"]["user"]
  cwd "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}"
end

execute "redmine-setup-db" do
  command "bundle exec rake db:migrate RAILS_ENV='production'"
  user node["apache"]["user"]
  cwd "#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}"
  not_if { ::File.exists?("#{node["redmine"]["basedir"]}/redmine-#{node["redmine"]["version"]}/db/schema.rb") }
end
