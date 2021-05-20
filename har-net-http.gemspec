# frozen_string_literal: true

require_relative "lib/har/net/http/version"

Gem::Specification.new do |spec|
  spec.name          = "har-net-http"
  spec.version       = Har::Net::HTTP::VERSION
  spec.authors       = ["Aslak Hellesøy"]
  spec.email         = ["aslak.hellesoy@smartbear.com"]

  spec.summary       = "Capture HAR files from net/http requests."
  spec.homepage      = "https://github.com/cucumber/har-net-http"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cucumber/har-net-http"
  spec.metadata["changelog_uri"] = "https://github.com/cucumber/har-net-http/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
