# -*- encoding: utf-8 -*-
scope group: :unit

ignore(%r{^\.gem/}, %r{^\.kitchen/})

# directories %w(attributes files providers recipes resources templates)
watch('config/Guardfile') do
  UI.info 'Exiting guard because config changed'
  exit 0
end

group :unit do
  guard :rubocop do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
  # --tags ~FC007 --tags ~FC015 --tags ~FC023
  guard :foodcritic, cli: '--epic-fail any -t ~FC015', cookbook_paths: '.' do
    watch(%r{attributes/.+\.rb$})
    watch(%r{providers/.+\.rb$})
    watch(%r{recipes/.+\.rb$})
    watch(%r{resources/.+\.rb$})
    watch(%r{templates/.+\.erb$})
  end

  # guard :rspec, cmd: 'bundle exec rspec --color --fail-fast', all_on_start: false do
  #   watch(/^spec\/(.+)_spec\.rb$/)
  #   watch(/^(recipes)\/(.+)\.rb$/)   { |m| "spec/#{m[1]}_spec.rb" }
  #   watch('spec/spec_helper.rb')     { 'spec' }
  # end
end

group :integration do
  guard :kitchen do
    watch(/.+\.rb$/)
    watch(%r{^files/.*$})
    watch(/.kitchen.yml$/)
  end
end