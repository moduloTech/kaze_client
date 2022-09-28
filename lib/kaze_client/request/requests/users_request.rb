# frozen_string_literal: true

module KazeClient
  # @author chevre_a@modulotech.fr
  # List the users from the current user's company.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.0
  class UsersRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest

    def initialize
      super(:get, 'api/users')
    end
  end
end
