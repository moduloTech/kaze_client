# frozen_string_literal: true

require 'kaze_client'
require 'debug'

# Stub all HTTP and forbid real network connections: any unstubbed request raises.
require 'webmock/rspec'
WebMock.disable_net_connect!

module SpecHelpers

  # Read a captured response fixture from spec/fixtures.
  # @param name [String] The fixture base name (without extension)
  # @return [String] The raw fixture body
  def fixture(name)
    File.read(File.expand_path("fixtures/#{name}.json", __dir__))
  end

end

RSpec.configure do |config|
  config.include SpecHelpers

  # The global configuration is process-wide; reset it between examples to avoid leaks.
  config.after { KazeClient.reset_configuration! }

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
