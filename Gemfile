source 'https://rubygems.org'

gem 'berkshelf'
gem 'chef'
gem 'knife-cleanup'

group :unit do
  gem 'foodcritic'
  gem 'rubocop'
  gem 'chefspec'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end

group :development do
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-foodcritic', git: 'https://github.com/trickyearlobe/guard-foodcritic.git', branch: 'add_guard_2.x_compatibility'
  gem 'guard-kitchen', git: 'https://github.com/trickyearlobe/guard-kitchen.git', branch: 'support_guard_2'
  gem 'guard-rspec'
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
end
