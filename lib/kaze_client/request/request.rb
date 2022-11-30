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
      'Accept'       => 'application/json'
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
      @method  = method
      @url     = url
      @query   = nil
      @body    = nil
      @headers = {}
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
    #   If +@headers+ is blank or is not a Hash, it returns the +DEFAULT_HEADERS+. Else it merges
    #   the +DEFAULT_HEADERS+ with +@headers+ allowing +@headers+ to override +DEFAULT_HEADERS+.
    def make_headers
      return DEFAULT_HEADERS if @headers.blank? || !@headers.is_a?(Hash)

      DEFAULT_HEADERS.merge(@headers)
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
      # This means no error class exists for the error code in the response, we fallback to a
      # generic error
      Error::Generic.new(status: response.code, error: error, message: message)
    end

    def generic_http_error(error, message, response)
      case response.code
      when 401
        KazeClient::Error::Unauthorized.new(message)
      when 403
        KazeClient::Error::Forbidden.new(message)
      when 404
        KazeClient::Error::NotFound.new
      when 500
        KazeClient::Error::InternalServerError.new(message)
      else
        # This means no error class exists for the response code, we fallback to a generic error
        Error::Generic.new(status: response.code, error: error, message: message)
      end
    end
  end
end
