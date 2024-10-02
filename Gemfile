# frozen_string_literal: true

source 'https://rubygems.org'

ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 2.7']

gem 'safe_yaml'

gem 'builder'
gem 'parallel'
gem 'puppet', '~> 7.0'
gem 'rake'
gem 'rubocop'
gem 'rubocop-rspec'
gem 'ruby-lsp'

gem 'json_pure'

gem 'hiera'
gem 'hiera-puppet'

group :test do
  gem 'mocha', '~> 0.13', require: false

  gem 'test-unit'
end
