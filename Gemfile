# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) {|repo_name| 'https://github.com/#{repo_name}' }

# Specify your gem's dependencies in komponent.gemspec
gemspec

gem 'rails'
gem 'rake', '>= 11.1'
gem 'rubocop', require: false
gem 'webpacker'

group :test do
  gem 'aruba'
  gem 'coveralls', require: false
  gem 'cucumber'
  gem 'simplecov', require: false
end
