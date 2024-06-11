# frozen_string_literal: true

module KazeClient

  # @author bourdat_c@modulotech.fr
  # Delete a collection item
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.1
  class DeleteCollectionItemRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @param collection_id [String]
    # @param item_id [String]
    def initialize(collection_id, item_id)
      super(:delete, "api/collections/#{collection_id}/items/#{item_id}")
    end

  end

end
