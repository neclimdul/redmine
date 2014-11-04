#
# Author: James Gilliland (<neclimdul@gmail.com>)
# Cookbook Name:: redmine
# Definition:: redmine_plugin
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

define :redmine_plugin, :repository => nil do
  include_recipe "redmine::plugins"

  # Default Assignee plugin
  git "#{node["redmine"]["basedir"]}/shared/plugins/#{params[:name]}" do
    repository params[:repository]
    action :sync
    notifies :run, "execute[redmine-plugin-migration]", :delayed
    notifies :restart, "service[apache2]", :delayed
  end
end
