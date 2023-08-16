# frozen_string_literal: true

module KazeClient

  # @author chevre_a@modulotech.fr
  # Fetch all tags
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  class TagsRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    def initialize
      super(:get, 'api/tags')
    end

  end

end
