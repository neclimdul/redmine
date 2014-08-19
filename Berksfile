source "https://api.berkshelf.com"
metadata

cookbook 'application'
cookbook 'application_ruby', git: "https://github.com/poise/application_ruby.git"
cookbook 'database'
cookbook 'apache2'
group :integration do
  cookbook 'apt', '~> 2.0'
  cookbook 'mysql', '~> 5.0'
  cookbook 'passenger_apache2'
end

