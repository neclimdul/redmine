name              "redmine"
maintainer        "Opscode, Inc."
maintainer_email  "neclimdul@gmail.com"
license           "Apache 2.0"
description       "Installs and configures redmine as a Rails app in passenger+apache2"
version           "0.13.0"

recipe "redmine", "Installs and configures redmine under passenger + apache2"

depends "apache2"
depends "openssl"
depends "imagemagick"

supports "ubuntu"
supports "debian"
