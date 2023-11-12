# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "unit_measurements/rails/version"

Gem::Specification.new do |spec|
  spec.name = "unit_measurements-rails"
  spec.version = UnitMeasurements::Rails::VERSION
  spec.authors = ["Harshal LADHE"]
  spec.email = ["harshal.ladhe.1@gmail.com"]

  spec.description = "A Rails adaptor that encapsulate measurements and their units in Ruby on Rails."
  spec.summary = "Rails adaptor for unit_measurements"
  spec.homepage = "https://github.com/shivam091/unit_measurements-rails"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shivam091/unit_measurements-rails"
  spec.metadata["changelog_uri"] = "https://github.com/shivam091/unit_measurements-rails/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://shivam091.github.io/unit_measurements-rails"
  spec.metadata["bug_tracker_uri"] = "https://github.com/shivam091/unit_measurements-rails/issues"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "railties", ">= 7"
  spec.add_runtime_dependency "activemodel", ">= 7"
  spec.add_runtime_dependency "activerecord", ">= 7"

  spec.add_runtime_dependency "unit_measurements", "~> 5"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.21", ">= 0.21.2"
  spec.add_development_dependency "byebug", "~> 11"
  spec.add_development_dependency "sqlite3", "~> 1.6"

  spec.required_ruby_version = ">= 3.2"
end
