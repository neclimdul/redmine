# Cookbook Name:: redmine
# Attributes:: redmine
#
# Copyright 2009, Opscode, Inc
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

require 'openssl'

pw = String.new

while pw.length < 20
  pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

#database_server = search(:node, "database_master:true").map {|n| n['fqdn']}.first

default["redmine"]["version"] = "2.4.5"

set["redmine"]["basedir"] = "/srv"
set["redmine"]["dir"] = "#{redmine["basedir"]}/redmine-#{redmine["version"]}"

default["redmine"]["db"]["type"]     = "mysql"
default["redmine"]["db"]["dbname"]     = "redmine"
default["redmine"]["db"]["user"]     = "redmine"
default["redmine"]["db"]["password"] = pw
default["redmine"]["db"]["hostname"] = "localhost"
# https://tickets.opscode.com/browse/COOK-3487
default["redmine"]["db"]["recipe"] = "mysql::client"

default["redmine"]["server_name"] = "#{node["hostname"]}.#{node["domain"]}"
default["redmine"]["server_aliases"] = [node["hostname"]]

default['redmine']['ssl_chain'] = nil
case node['platform']
when 'debian', 'ubuntu'
  default['redmine']['ssl_key'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
  default['redmine']['ssl_cert'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['redmine']['ssl_key'] = '/etc/pki/tls/private/redmine.key'
  default['redmine']['ssl_cert'] = '/etc/pki/tls/certs/redmine.pem'
end
