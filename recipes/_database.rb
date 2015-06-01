#
# Author: Joshua Timberman <joshua@housepub.org>
# Author: James Gilliland (<neclimdul@gmail.com>)
# Cookbook Name:: redmine
# Recipe:: _database
#
# Copyright 2008-2009, Joshua Timberman
# Copyright 2014, James Gilliland
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

include_recipe node['redmine']['db']['server_recipe'] unless node['redmine']['db']['server_recipe'].empty?
include_recipe node['redmine']['db']['client_recipe'] unless node['redmine']['db']['client_recipe'].empty?

if node['redmine']['db']['type'] == 'sqlite'
  gem_package 'sqlite3-ruby'
  file "#{node['redmine']['basedir']}/redmine-#{node['redmine']['version']}/db/production.db" do
    owner node['apache']['user']
    group node['apache']['user']
    mode '0644'
  end

else
  connection_info = {
    host: node['redmine']['db']['host']
  }

  case node['redmine']['db']['type']
  when 'mysql', 'mariadb'
    if node['redmine']['db']['type'] == 'mariadb'
      gem_provider = Chef::Provider::Mysql2ChefGem::Mariadb
    else
      gem_provider = Chef::Provider::Mysql2ChefGem::Mysql
    end
    mysql2_chef_gem 'default' do
      provider gem_provider
      action :install
    end
    db_provider = Chef::Provider::Database::Mysql
    user_provider = Chef::Provider::Database::MysqlUser
    connection_info.merge!(
      username: 'root',
      password: node['mysql']['server_root_password']
    )
  when 'postgres'
    include_recipe 'database::postgres'
    db_provider = Chef::Provider::Database::Postgresql
    user_provider = Chef::Provider::Database::PostgresqlUser
    connection_info.merge!(
      port: node['postgresql']['config']['port'],
      username: 'postgres',
      password: node['postgresql']['password']['postgres']
    )
  when 'sqlserver'
    db_provider = Chef::Provider::Database::SqlServer
    user_provider = Chef::Provider::Database::SqlServerUser
    connection_info.merge!(
      port: node['sql_server']['port'],
      username: 'sa',
      password: node['sql_server']['server_sa_password']
    )
  end

  database node['redmine']['db']['database'] do
    provider db_provider
    connection connection_info
    action :create
  end
  database_user node['redmine']['db']['username'] do
    provider user_provider
    connection connection_info
    password node['redmine']['db']['password']
    privileges [:all]
    action :grant
  end
end
