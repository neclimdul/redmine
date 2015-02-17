#
# Author: James Gilliland (<neclimdul@gmail.com>)
# Cookbook Name:: redmine
# Recipe:: _application
#
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

include_recipe 'application'
include_recipe 'imagemagick::devel'

package 'git' do
  action :install
end

db = node['redmine']['db'].to_hash
case node['redmine']['db']['type']
when 'mysql', 'mariadb'
  db[:adapter] = 'mysql2'
when 'postgres'
  db[:adapter] = 'postgres'
when 'sqlserver'
  db[:adapter] = 'sqlserver'
when 'sqlite'
  db[:adapter] = 'sqlite3'
end
db.delete('type')

%w(files plugins logs).each do |dir|
  directory "#{node['redmine']['basedir']}/shared/#{dir}" do
    owner node['apache']['user']
    recursive true
  end
end

application 'redmine' do
  path node['redmine']['basedir']
  # Allow deploy from non-master commits/branches.
  shallow_clone false
  repository 'https://github.com/redmine/redmine.git'
  revision node['redmine']['version']
  migrate true

  purge_before_symlink %w(files plugins logs)
  symlinks(
    'files'   => 'files',
    'plugins'   => 'plugins',
    'logs' => 'logs'
  )
  rails do
    gems ['bundler']
    database db
  end

  before_migrate do
    # this is a bit ugly linking the database config early but redmine's Gemfile looks at so we need it during the bundle run.
    execute 'ln -s ../../../shared/database.yml config/database.yml' do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  end
  before_restart do
    execute 'bundle exec rake generate_secret_token' do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  end

  passenger_apache2 do
    server_aliases node['redmine']['server_aliases']
    params(
      'server_name' => node['redmine']['server_name'],
      'ssl_key' => node['redmine']['ssl_key'],
      'ssl_cert' => node['redmine']['ssl_cert'],
      'ssl_chain' => node['redmine']['ssl_chain'],
      'passenger_user' => node['apache']['user']
    )
  end
end

directory "#{node['redmine']['basedir']}/current/tmp" do
  owner node['apache']['user']
  recursive true
  subscribes :run, 'application[redmine]'
end
directory "#{node['redmine']['basedir']}/current/public/plugin_assets" do
  owner node['apache']['user']
  subscribes :run, 'application[redmine]'
  recursive true
end
file "#{node['redmine']['basedir']}/current/Gemfile.lock" do
  owner node['apache']['user']
  subscribes :run, 'application[redmine]'
end
