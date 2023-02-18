# frozen_string_literal: true

module KazeClient
  # @author richar_p@modulotech.fr
  # List the collections for the company of the current user.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.2
  class CollectionsRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest

    def initialize
      super(:get, 'api/collections')
    end
  end
end
