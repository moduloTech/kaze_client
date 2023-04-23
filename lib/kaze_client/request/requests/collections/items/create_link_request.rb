# frozen_string_literal: true

module KazeClient
  module Collection
    module Item
      class CreateLinkRequest < Utils::FinalRequest
        include Utils::AuthentifiedRequest

        # @author chevre_a@modulotech.fr
        # Create a link between 2 collection items
        # @see KazeClient::Request
        # @see KazeClient::Utils::FinalRequest
        # @see KazeClient::Utils::AuthentifiedRequest
        # @since 0.3.2
        def initialize(collection_id, collection_item_id, linked_collection_item_id)
          super(:post, "api/collections/#{collection_id}/items/#{collection_item_id}/links")

          @body = { id: linked_collection_item_id }
        end
      end
    end
  end
end
