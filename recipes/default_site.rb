#
# Author: Joshua Timberman <joshua@housepub.org>
# Author: James Gilliland (<neclimdul@gmail.com>)
# Cookbook Name:: redmine
# Recipe:: default_site
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

# Create default virtual redirecting to SSL virtualhost.
web_app "redmine" do
  template "redmine.conf.erb"
  server_name node["redmine"]["server_name"]
  server_aliases node["redmine"]["server_aliases"]
end

include_recipe 'apache2::mod_ssl'

# Create SSL virtualhost
web_app 'redmine-ssl' do
  docroot "#{node["redmine"]["basedir"]}/redmine/public"
  template "redmine-ssl.conf.erb"
  server_name node["redmine"]["server_name"]
  server_aliases node["redmine"]["server_aliases"]
  rails_env "production"

  ssl_key node["redmine"]["ssl_key"]
  ssl_cert node["redmine"]["ssl_cert"]
  ssl_chain node["redmine"]["ssl_chain"]
end
