# frozen_string_literal: true

module KazeClient

  module Collection

    # @author richar_p@modulotech.fr
    # List the items assigned to the collection id.
    # @see KazeClient::Request
    # @see KazeClient::Utils::FinalRequest
    # @see KazeClient::Utils::AuthentifiedRequest
    # @since 0.3.2
    class ItemsRequest < Utils::FinalRequest

      include Utils::AuthentifiedRequest
      include Utils::ListRequest

      def initialize(id)
        super(:get, "api/collections/#{id}/items")
      end

    end

  end

end
