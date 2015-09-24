name 'redmine'
maintainer 'Opscode, Inc.'
maintainer_email 'neclimdul@gmail.com'
license 'Apache 2.0'
description 'Installs and configures redmine as a Rails app in passenger+apache2'
version '2.1.1'

recipe 'redmine', 'Installs and configures redmine under passenger + apache2'

# these are weird. see https://github.com/poise/application_ruby/issues/70 and Berksfile
depends 'application'
depends 'application_ruby'
depends 'database', '~> 4.0'
depends 'mysql2_chef_gem', '~> 1.0'
depends 'apache2'
depends 'openssl'
depends 'imagemagick'

supports 'ubuntu'
supports 'debian'
