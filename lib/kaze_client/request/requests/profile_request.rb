# frozen_string_literal: true

module KazeClient
  # @author ciappa_m@modulotech.fr
  # Request data about the current user.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class ProfileRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize
      super(:get, 'api/profile')
    end
  end
end
