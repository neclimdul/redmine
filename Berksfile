source 'https://supermarket.chef.io'
metadata

cookbook 'apt', '~> 2.0'

# Workaround https://github.com/poise/application_ruby/issues/70
cookbook 'application', '~> 4.1'
cookbook 'application_ruby', git: 'https://github.com/poise/application_ruby.git', ref: '0cfc68c41fb141c7ce5955390df9c537855fd820'
cookbook 'apache2', '~> 3.0'
cookbook 'passenger_apache2'

cookbook 'database', '~> 4.0'
cookbook 'mysql', '~> 6.0'
cookbook 'mysql2_chef_gem', '~> 1.0'

cookbook 'mysql_client_test', path: 'test/fixtures/cookbooks/mysql_client_test'
cookbook 'mysql_service_test', path: 'test/fixtures/cookbooks/mysql_service_test'
