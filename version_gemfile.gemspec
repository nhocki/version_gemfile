# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version_gemfile/version'

Gem::Specification.new do |gem|
  gem.name          = "version_gemfile"
  gem.version       = VersionGemfile::VERSION
  gem.authors       = ["Nicolás Hock Isaza"]
  gem.email         = ["nhocki@gmail.com"]
  gem.description   = %q{Tool to add version to your Gemfile's gems.}
  gem.summary       = %q{Prevent future problems dude. Add the versions and move on.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
