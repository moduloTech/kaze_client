# frozen_string_literal: true

require_relative 'lib/kaze_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'kaze_client'
  spec.version       = KazeClient::VERSION
  spec.authors       = ['Matthieu Ciappara']
  spec.email         = ['ciappa_m@modulotech.fr']

  spec.summary       = 'This is the official Ruby client library for Kaze API.'
  spec.description = <<~TEXT
    This is the official Ruby client library for Kaze (https://www.kaze.so/) API.

    The API documentation can be found at https://documenter.getpostman.com/view/15303175/U16nLQ7r.
  TEXT
  spec.homepage      = 'https://github.com/moduloTech/kaze_client'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moduloTech/kaze_client'
  spec.metadata['changelog_uri'] = 'https://github.com/moduloTech/kaze_client/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.18', '>= 0.18.1'
  spec.add_runtime_dependency 'jsonpath', '~> 1.1', '>= 1.1.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
