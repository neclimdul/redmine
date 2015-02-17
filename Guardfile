# -*- encoding: utf-8 -*-
scope group: :unit

ignore(/^\.gem\//, /^\.kitchen\//)

# directories %w(attributes files providers recipes resources templates)
watch('config/Guardfile') do
  UI.info 'Exiting guard because config changed'
  exit 0
end

group :unit do
  guard :rubocop do
    watch(/.+\.rb$/)
    watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
  end
  # --tags ~FC007 --tags ~FC015 --tags ~FC023
  guard :foodcritic, cli: '--epic-fail any', cookbook_paths: '.' do
    watch(/attributes\/.+\.rb$/)
    watch(/providers\/.+\.rb$/)
    watch(/recipes\/.+\.rb$/)
    watch(/resources\/.+\.rb$/)
    watch(/templates\/.+\.erb$/)
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
    watch(/^files\/.*$/)
    watch(/.kitchen.yml$/)
  end
end
