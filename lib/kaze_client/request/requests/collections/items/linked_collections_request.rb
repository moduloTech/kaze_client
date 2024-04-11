# frozen_string_literal: true

module KazeClient

  module Collection

    module Item

      class LinkedCollectionsRequest < Utils::FinalRequest

        include Utils::AuthentifiedRequest
        include Utils::ListRequest

        # @author bourda_c@modulotech.fr
        # Fetch all items linked to a given item
        # @see KazeClient::Request
        # @see KazeClient::Utils::FinalRequest
        # @see KazeClient::Utils::AuthentifiedRequest
        # @see KazeClient::Utils::ListRequest
        # @since 0.4.1
        def initialize(collection_id, collection_item_id)
          super(:get, "api/collections/#{collection_id}/items/#{collection_item_id}/linked_collections")
        end

      end

    end

  end

end
