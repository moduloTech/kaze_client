# frozen_string_literal: true

module KazeClient
  # @author richar_p@modulotech.fr
  # Fetch the details for the given item id from the given collection id.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.2
  class ItemRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(collection_id, item_id)
      super(:get, "api/collection/#{collection_id}/items/#{item_id}")
    end
  end
end
