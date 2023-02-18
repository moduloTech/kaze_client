# frozen_string_literal: true

module KazeClient
  # @author richar_p@modulotech.fr
  # Fetch the details for the given collection id.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.2
  class CollectionRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(id)
      super(:get, "api/collections/#{id}")
    end
  end
end
