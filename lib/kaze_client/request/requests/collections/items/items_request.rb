# frozen_string_literal: true

module KazeClient
  # @author richar_p@modulotech.fr
  # List the items assigned to the collection id.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.0
  class ItemsRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest
    def initialize(id)
      super(:get, "api/collections/#{id}/items")
    end
  end
end
