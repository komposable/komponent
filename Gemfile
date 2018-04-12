# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in komponent.gemspec
gemspec

gem "rails"
gem "rake", ">= 11.1"
gem "rubocop", require: false

group :test do
  gem "aruba"
  gem "cucumber"
  gem "simplecov", require: false
  gem "coveralls", require: false
end
