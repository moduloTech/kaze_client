# frozen_string_literal: true

module KazeClient

  # @author ciappa_m@modulotech.fr
  # Execute a KazeClient::Request, stores the server's base URL, the request and the response.
  # @see KazeClient::Request
  # @see KazeClient::Response
  # @since 0.1.0
  class Client

    # @return [String] The server's base URL (e.g. https://app.kaze.so)
    attr_reader :base_url
    # @return [String,nil] The last authentication token
    # @see KazeClient::Client#login
    attr_reader :token

    # @param base_url [String] The server's base URL (e.g. https://app.kaze.so)
    # @param token [String] The authentication token
    def initialize(base_url, token: nil)
      @base_url = base_url
      @token    = token
      @login    = nil
      @password = nil
    end

    # Execute a request
    #
    # If the request needs authentication (meaning it includes KazeClient::Utils::AuthentifiedRequest)
    # it sets the authentication token.
    #
    # @see KazeClient::Client#login
    # @param request [KazeClient::Request] The request to execute
    # @return [KazeClient::Response] The response from the server
    # @raise [KazeClient::Error::NoEndpoint] if the base URL is blank
    # @raise [KazeClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
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
    # @return [KazeClient::Response] The response from the server
    # @raise [KazeClient::Error::NoEndpoint] if the base URL is blank
    # @raise [KazeClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    # @see KazeClient::Client#do_execute
    def login(login=@login, password=@password)
      # Impossible to login using nil login or password.
      # The first call to #login must be given a login and a password.
      raise KazeClient::Error::InvalidCredentials, 'Please set login and password' if login.nil? || password.nil?

      request = KazeClient::LoginRequest.new(login: login, password: password)

      response = do_execute(request)

      # Store the token for next request and the login/password for next call
      @token    = response['token']
      @login    = login
      @password = password

      response
    end

    # Set the authentication token
    #
    # @param token [String] The new authentication token
    # @return [KazeClient::Client] The client after assigning the new token
    def with_token(token)
      @token = token

      self
    end

    private

    # @param request [KazeClient::Request] The request which was executed
    # @return [true] if the response is a success: 2xx HTTP status
    # @raise [KazeClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
    def handle_errors(request)
      return true if @response.success?

      raise request.error_for(@response)
    end

    # @param request [KazeClient::Request] The request to execute
    # @return [KazeClient::Response] The response from the server
    # @raise [KazeClient::Error::NoEndpoint] if the base URL is blank
    # @raise [KazeClient::Error::Generic] if the response is not a success: not a 2xx HTTP status
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
