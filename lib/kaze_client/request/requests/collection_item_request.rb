# frozen_string_literal: true

module KazeClient
  # @author chevre_a@modulotech.fr
  # Fetch the details for the given collection item id.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  class CollectionItemRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    # @param collection_id [String]
    # @param collection_item_id [String]
    def initialize(collection_id, collection_item_id)
      super(:get, "api/collections/#{collection_id}/items/#{collection_item_id}")
    end
  end
end
