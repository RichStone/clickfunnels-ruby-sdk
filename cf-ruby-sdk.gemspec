# frozen_string_literal: true

require_relative "lib/cf/version"

Gem::Specification.new do |spec|
  spec.name = "cf-ruby-sdk"
  spec.version = CF::VERSION
  spec.authors = ["Rich Steinmetz", "Claude Code"]
  spec.email = ["hey@richsteinmetz.com"]

  spec.summary = "Ruby SDK for ClickFunnels API"
  spec.description = "A simple, dynamic Ruby SDK for the ClickFunnels API with support for all endpoints and operations."
  spec.homepage = "https://github.com/RichStone/clickfunnels-ruby-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.6"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*", "README.md", "LICENSE", "CHANGELOG.md"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "json", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end