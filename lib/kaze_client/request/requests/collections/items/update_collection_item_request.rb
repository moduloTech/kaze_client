# frozen_string_literal: true

module KazeClient

  # @author bourdat_c@modulotech.fr
  # Update a collection item
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.1
  class UpdateCollectionItemRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @param collection_id [String]
    # @param item_id [String]
    # @param payload [Hash]
    def initialize(collection_id, item_id, payload)
      super(:put, "api/collections/#{collection_id}/items/#{item_id}")

      @body = payload
    end

  end

end
