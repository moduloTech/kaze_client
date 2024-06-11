# frozen_string_literal: true

module KazeClient

  # @author bourda_c@modulotech.fr
  # Show a given user's informations.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.1
  class UserRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    def initialize(user_id)
      super(:get, "api/users/#{user_id}")
    end

  end

end
