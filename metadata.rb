name              "redmine"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures redmine as a Rails app in passenger+apache2"
version           "0.12.3"

recipe "redmine", "Installs and configures redmine under passenger + apache2"

depends "apache2"

supports "ubuntu"
supports "debian"
