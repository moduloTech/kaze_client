# frozen_string_literal: true

module KazeClient

  # @author ciappa_m@modulotech.fr
  # Represents request to a Kaze API
  # @see KazeClient::Client
  # @see KazeClient::Response
  # @since 0.1.0
  class Request

    # Those headers are added on all requests by default
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'Accept'       => 'application/json',
      'User-Agent'   => "kaze_client/#{KazeClient::VERSION}"
    }.freeze

    # @return [String, Symbol] The HTTP verb to use for the request
    # @example Common HTTP verbs
    #   [:get, :post, :put, :patch, :delete]
    attr_reader :method

    # @return [String] The API endpoint
    # @example To get the list of companies
    #   '/api/companies'
    attr_reader :url

    # @return [nil, Hash] The query parameters for the request
    # @example Page parameters from KazeClient::Utils::ListRequest
    #   { page: 1, per_page: 20 }
    attr_accessor :query

    # @return [nil, Hash, String] The body for the request
    # @example Login data from KazeClient::LoginRequest
    #   { user: { login: 'test', password: 'test' } }
    #   "{\"user\":{\"login\":\"test\",\"password\":\"test\"}}"
    attr_accessor :body

    # @return [nil, Hash] The headers for the request
    # @example Default headers from any KazeClient::Request
    #   { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    attr_accessor :headers

    # @param method [Symbol] The HTTP verb to use for the request (e.g. :get)
    # @param url [String] The API endpoint (e.g. /jobs)
    def initialize(method, url)
      @method         = method
      @url            = url
      @query          = nil
      @body           = nil
      @headers        = {}
      @client_headers = {}
    end

    # Store the headers configured on the executing client so they can be merged
    # into the request. Called by KazeClient::Client at execution time.
    #
    # @param headers [Hash, nil] The client-level headers
    # @return [KazeClient::Request] self (to chain methods)
    # @see KazeClient::Client
    def with_client_headers(headers)
      @client_headers = headers.is_a?(Hash) ? headers : {}

      self
    end

    # @return [Hash] The arguments to give to the HTTParty call
    # @example For instance, when +@body+ is blank
    #   {
    #     query: { page: 1, per_page: 20 },
    #     headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    #   }
    def parameters
      {
        query: make_query, body: make_body, headers: make_headers
      }.reject { |_k, v| v.blank? }
    end

    # @param response [HTTParty::Response] The response object from HTTParty call
    # @return [KazeClient::Error::Generic] The adequate error object according to the given response
    def error_for(response)
      error   = response.parsed_response['error']
      message = response.parsed_response['message']

      return non_generic_error(error, message, response) if error != 'generic'

      generic_http_error(error, message, response)
    end

    protected

    # @return [Hash] The headers for the request
    #   Headers are merged with the following precedence (later overrides earlier):
    #   +DEFAULT_HEADERS+, the globally configured headers (+KazeClient.configuration.headers+),
    #   the client-level headers (+KazeClient::Client.new(headers:)+), then the per-request +@headers+.
    # @see KazeClient.configure
    # @see KazeClient::Client
    def make_headers
      base = DEFAULT_HEADERS.merge(KazeClient.configuration.headers).merge(@client_headers)

      return base if @headers.blank? || !@headers.is_a?(Hash)

      base.merge(@headers)
    end

    # @return [nil, String] The body for the request
    #   +String+ will be sent as-is while +Hash+ will be transformed to a JSON string.
    def make_body
      return nil if @body.blank?

      case @body
      when String
        @body
      when Hash
        @body.to_json
      else
        @body.to_s
      end
    end

    # @return [nil, Hash] The query parameters for the request
    def make_query
      return nil if @query.blank?

      @query
    end

    def non_generic_error(error, message, response)
      # Return the adequate error class for the error code in the response
      "KazeClient::Error::#{error.camelize}".constantize.new(message)
    rescue NameError
      generic_http_error(error, message, response)
    end

    def generic_http_error(error, message, response)
      case response.code
      when 401 then KazeClient::Error::Unauthorized.new(message)
      when 403 then KazeClient::Error::Forbidden.new(message)
      when 404 then KazeClient::Error::NotFound.new
      when 500 then KazeClient::Error::InternalServerError.new(message)
      else
        # This means no error class exists for the response code, we fallback to a generic error
        Error::Generic.new(status: response.code, error: error, message: message)
      end
    end

  end

end
