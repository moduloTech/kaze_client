# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Represents request to a LastBill API
  # @see LastbillClient::Client
  # @see LastbillClient::Response
  # @since 0.1.0
  class Request
    # Those headers are added on all requests by default
    DEFAULT_HEADERS = {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
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
    # @example Page parameters from LastbillClient::Utils::ListRequest
    #   { page: 1, per_page: 20 }
    attr_accessor :query

    # @return [nil, Hash, String] The body for the request
    # @example Login data from LastbillClient::LoginRequest
    #   { user: { login: 'test', password: 'test' } }
    #   "{\"user\":{\"login\":\"test\",\"password\":\"test\"}}"
    attr_accessor :body

    # @return [nil, Hash] The headers for the request
    # @example Default headers from any LastbillClient::Request
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
    # @return [LastbillClient::Error::Generic] The adequate error object according to the given response
    def error_for(response)
      # Not found is handled in a specific way since there is no message key and the error has a
      # specific format
      return LastbillClient::Error::NotFound.new if response.code == 404

      # Return the adequate error class for the error code in the response
      "LastbillClient::Error::#{response.parsed_response["error"].camelize}"
        .constantize.new(response.parsed_response["message"])
    rescue NameError
      # This means no error class exists for the error code in the response, we fallback to a
      # generic error
      Error::Generic.new(status: response.code,
                         error: response.parsed_response["error"],
                         message: response.parsed_response["message"])
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
      end
    end

    # @return [nil, Hash] The query parameters for the request
    def make_query
      return nil if @query.blank?

      @query
    end
  end
end
