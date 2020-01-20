# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "komponent/version"

Gem::Specification.new do |spec|
  spec.name        = "komponent"
  spec.version     = Komponent::VERSION
  spec.authors     = ["Ouvrages"]
  spec.email       = ["contact@ouvrages-web.fr"]

  spec.summary     = "An opinionated way of organizing front-end code in Ruby on Rails, based on components"
  spec.description = "An opinionated way of organizing front-end code in Ruby on Rails, based on components"
  spec.homepage    = "http://komponent.io"
  spec.license     = "MIT"

  spec.metadata    = {
    "homepage_uri"    => "http://komponent.io",
    "changelog_uri"   => "https://github.com/komposable/komponent/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/komposable/komponent",
    "bug_tracker_uri" => "https://github.com/komposable/komponent/issues",
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|fixtures|gemfiles)/})
  end

  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency "actionview", ">= 5.0"
  spec.add_dependency "activesupport", ">= 5.0"
  spec.add_dependency "railties", ">= 5.0"
  spec.add_dependency "webpacker", ">= 3.0.0"

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler", ">= 2.0.0", "< 2.2.0"
end
