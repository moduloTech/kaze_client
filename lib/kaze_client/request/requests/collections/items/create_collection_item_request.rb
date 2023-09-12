# frozen_string_literal: true

module KazeClient

  # @author chevre_a@modulotech.fr
  # Create a collection item
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.2
  class CreateCollectionItemRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @param collection_id [String]
    # @param payload [Hash]
    def initialize(collection_id, payload)
      super(:post, "api/collections/#{collection_id}/items")

      @body = payload
    end

  end

end
