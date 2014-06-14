# Description

Installs Redmine, a Ruby on Rails ticket tracking and wiki tool.

# Requirements

## Platform:

Tested on Ubuntu 12.04.

## Cookbooks:

Opscode cookbooks (http://github.com/opscode/cookbooks/tree/master)

Required:
* apache2

Suggested:
* git
* sqlite
* mysql
* passenger_apache2
* rails

# Attributes

* node['redmine']['version] - Release version of redmine to use.
* node['redmine']['basedir'] - Base directory where redmine will be installed, such as "/srv"
* node['redmine']['dir'] - Directory where redmine will be installed, such as "#{redmine[:basedir]}/redmine-#{redmine[:version]}"
* node['redmine']['db']['recipe'] - Database cookbook recipe. This can by sqlite, postgres or mysql. It also allows different mysql flavors like mariadb or site specific database recipes.
* node['redmine']['db']['type'] - Type of database to use, default is sqlite. mysql or postgresql can be used. Used for connection driver.
* node['redmine']['db']['dbname'] - The name of the database schema, default is redmine.
* node['redmine']['db']['user'] - Database user to connect as, default is redmine.
* node['redmine']['db']['password'] - Password for the user, default is a random string generated with OpenSSL::Random.random_bytes.
* node['redmine']['db']['hostname'] - Hostname of database server, default is localhost.
* node['redmine']['server_name'] - Server name.
* node['redmine']['server_aliases'] - Any server aliases.
* node['redmine']['ssl_key'] - Full path to ssl key
* node['redmine']['ssl_cert'] - Full path to ssl cert
* node['redmine']['ssl_chain'] - Full path to ssl certificate chain. If not supplied, no chain will be used.

# Usage

Including this recipe in a run_list, role or on a node will install Redmine as a Passenger application under Apache2.

    include_recipe "redmine"

Because of all the options for installing passenger it is assumed you have something in your runlist that handles this. For example:

    include_recipe "passenger_apache2::mod_rails"

You'll probably want to customize it to fit your environment, as a site-cookbook, especially if you want to use something besides sqlite as the database backend. The attributes file has database_master commented out as an example start on using a node search to determine a database host. See the Chef wiki regarding searches for more information.

  http://wiki.opscode.com/display/chef/Search+Indexes

# License and Author

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: James Gilliland (<neclimdul@gmail.com>)
Copyright:: 2009, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

