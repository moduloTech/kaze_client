# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Execute a LastbillClient::Request, stores the server's base URL, the request and the response.
  # @see LastbillClient::Request
  # @see LastbillClient::Response
  # @since 0.1.0
  class Client
    # @return [String] The server's base URL (e.g. https://www.lastbill.co)
    attr_reader :base_url
    # @return [String,nil] The last authentication token
    # @see LastbillClient::Client#login
    attr_reader :token

    # @param base_url [String] The server's base URL (e.g. https://www.lastbill.com)
    def initialize(base_url)
      @base_url = base_url
      @token    = nil
      @login    = nil
      @password = nil
    end

    # Execute a request
    #
    # If the request needs authentication (meaning it includes LastbillClient::Utils::AuthentifiedRequest)
    # it sets the authentication token.
    #
    # @see LastbillClient::Client#login
    # @param request [LastbillClient::Request] The request to execute
    # @return [LastbillClient::Response] The response from the server
    # @raise [LastbillClient::Error::NoEndpoint] if the base URL is blank
    # @raise [LastbillClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    def execute(request)
      if request.is_a?(Utils::AuthentifiedRequest) && request.token.nil?
        login if @token.nil?

        request.with_token(@token)
      end

      do_execute(request)
    end

    # Stores the given login and password, stores the token received from authentication.
    #
    # @param login [String] The user login.
    # @param password [String] The user password.
    # @return [LastbillClient::Response] The response from the server
    # @raise [LastbillClient::Error::NoEndpoint] if the base URL is blank
    # @raise [LastbillClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    # @see LastbillClient::Client#do_execute
    def login(login = @login, password = @password)
      # Impossible to login using nil login or password.
      # The first call to #login must be given a login and a password.
      raise LastbillClient::Error::InvalidCredentials, "Please set login and password" if login.nil? || password.nil?

      request = LastbillClient::LoginRequest.new(login: login, password: password)

      response = do_execute(request)

      # Store the token for next request and the login/password for next call
      @token    = response["token"]
      @login    = login
      @password = password

      response
    end

    private

    # @param request [LastbillClient::Request] The request which was executed
    # @return [true] if the response is a success: 2xx HTTP status
    # @raise [LastbillClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    def handle_errors(request)
      return true if @response.success?

      raise request.error_for(@response)
    end

    # @param request [LastbillClient::Request] The request to execute
    # @return [LastbillClient::Response] The response from the server
    # @raise [LastbillClient::Error::NoEndpoint] if the base URL is blank
    # @raise [LastbillClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    def do_execute(request)
      raise Error::NoEndpoint, @base_url if @base_url.blank?

      @request = request

      request_url = "#{@base_url}/#{request.url}"
      @response   = HTTParty.send(request.method, request_url, **@request.parameters)

      # This will raise if the response is not a success: not a 2xx HTTP status
      handle_errors(request)

      # Build the response object from the HTTParty response
      Response.new(@response)
    end
  end
end
