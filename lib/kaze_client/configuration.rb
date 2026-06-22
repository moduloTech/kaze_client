# frozen_string_literal: true

module KazeClient

  # Holds the global configuration shared by every request.
  #
  # The most common use case is to add custom headers that must be sent on
  # every request to the Kaze API (e.g. an API key, a tracing header, ...).
  #
  # @see KazeClient.configure
  # @since 0.4.0
  # @example Configure custom headers added to every request
  #   KazeClient.configure do |config|
  #     config.headers['X-Api-Key']    = 'my-api-key'
  #     config.headers['X-Request-Id'] = SecureRandom.uuid
  #   end
  class Configuration

    # @return [Hash] The headers added to every request.
    #   These are merged after +KazeClient::Request::DEFAULT_HEADERS+ but before
    #   the per-request headers, so a per-request header still takes precedence.
    attr_accessor :headers

    def initialize
      @headers = {}
    end

  end

  class << self

    # @return [KazeClient::Configuration] The global configuration object.
    def configuration
      @configuration ||= Configuration.new
    end

    # Configure the client globally.
    #
    # @yieldparam config [KazeClient::Configuration] The configuration to mutate.
    # @return [KazeClient::Configuration] The configuration after the block ran.
    # @example
    #   KazeClient.configure do |config|
    #     config.headers['X-Api-Key'] = 'my-api-key'
    #   end
    def configure
      yield(configuration) if block_given?

      configuration
    end

    # Reset the global configuration back to its defaults.
    #
    # @return [KazeClient::Configuration] The fresh configuration object.
    def reset_configuration!
      @configuration = Configuration.new
    end

  end

end
