# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jpm_geo/version"

Gem::Specification.new do |spec|
  spec.name          = "jpm_geo"
  spec.version       = JpmGeo::VERSION
  spec.authors       = ["Andrew Williams"]
  spec.email         = ["sobakasu@gmail.com"]

  spec.summary       = "Finds points within a distance of a latitude/longitude point using bounding coordinates"
  spec.homepage      = "https://github.com/sobakasu/jpm_geo"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sobakasu/jpm_geo"
  spec.metadata["changelog_uri"] = "https://github.com/sobakasu/jpm_geo/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
