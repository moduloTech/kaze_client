# frozen_string_literal: true

module KazeClient

  # @author ciappa_m@modulotech.fr
  # Authenticate a user on the server.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @since 0.1.0
  class LoginRequest < Utils::FinalRequest

    # @return [String] The user login.
    attr_reader :login

    # @param login [String] The user login.
    # @param password [String] The user password.
    def initialize(login:, password:)
      super(:post, 'api/login')

      @login    = login
      @password = password
      @body     = {
        user: {
          login:    @login,
          password: @password
        }
      }
    end

  end

end
