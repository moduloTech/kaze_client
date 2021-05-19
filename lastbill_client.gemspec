# frozen_string_literal: true

require_relative "lib/lastbill_client/version"

Gem::Specification.new do |spec|
  spec.name          = "lastbill_client"
  spec.version       = LastbillClient::VERSION
  spec.authors       = ["Matthieu Ciappara"]
  spec.email         = ["ciappa_m@modulotech.fr"]

  spec.summary       = "This is the official Ruby client library for LastBill API."
  spec.description = <<~TEXT
    This is the official Ruby client library for LastBill (https://www.lastbill.com/) API.

    The API documentation can be found at https://www.lastbill.com/api-docs.
  TEXT
  spec.homepage      = "https://github.com/moduloTech/lastbill_client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/moduloTech/lastbill_client"
  spec.metadata["changelog_uri"] = "https://github.com/moduloTech/lastbill_client/blob/master/CHANGELOG.md"

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
