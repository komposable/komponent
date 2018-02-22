lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "komponent/version"

Gem::Specification.new do |spec|
  spec.name          = "komponent"
  spec.version       = Komponent::VERSION
  spec.authors       = ["Ouvrages"]
  spec.email         = ["contact@ouvrages-web.fr"]

  spec.summary       = "An opinionated way of organizing front-end code in Ruby on Rails, based on components"
  spec.description   = "An opinionated way of organizing front-end code in Ruby on Rails, based on components"
  spec.homepage      = "http://komponent.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|fixtures)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "aruba"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "rails", ">= 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", '~> 0.52.1'

  spec.add_runtime_dependency "webpacker", ">= 3.0.0"
end
