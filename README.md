= DESCRIPTION:

Installs Redmine, a Ruby on Rails ticket tracking and wiki tool.

= REQUIREMENTS:

== Platform:

Tested on Ubuntu 9.04, uses the Opscode Apache2 cookbook which is Ubuntu/Debian specific.

== Cookbooks:

Opscode cookbooks (http://github.com/opscode/cookbooks/tree/master)

* git
* sqlite
* mysql
* rails
* passenger_apache2
* apache2

= ATTRIBUTES:

* redmine[:version] - release version of redmine to use.
* redmine[:basedir] - base directory where redmine will be installed, such as "/srv"
* redmine[:dir] - directory where redmine will be installed, such as "#{redmine[:basedir]}/redmine-#{redmine[:version]}"
* redmine[:db][:type] - type of database to use, default is sqlite. mysql or postgresql can be used, but the recipe will need to modified, and the next three attributes adjusted.
* redmine[:db][:user] - database user to connect as, default is redmine.
* redmine[:db][:password] - password for the user, default is a random string generated with OpenSSL::Random.random_bytes.
* redmine[:db][:hostname] - hostname of database server, default is localhost.

= USAGE:

Including this recipe in a run_list, role or on a node will install Redmine as a Passenger application under Apache2.

  include_recipe "redmine"

Because of all the options for installing passenger it is assumed you have something in your runlist that handles this. For example:

  include_recipe "passenger_apache2::mod_rails"

You'll probably want to customize it to fit your environment, as a site-cookbook, especially if you want to use something besides sqlite as the database backend. The attributes file has database_master commented out as an example start on using a node search to determine a database host. See the Chef wiki regarding searches for more information.

  http://wiki.opscode.com/display/chef/Search+Indexes

= LICENSE and AUTHOR:

Author:: Joshua Timberman (<joshua@opscode.com>)
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
