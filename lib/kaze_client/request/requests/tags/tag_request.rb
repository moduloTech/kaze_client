# frozen_string_literal: true

module KazeClient

  # @author chevre_a@modulotech.fr
  # Fetch a tag with the given id
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  class TagsRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @param tag_id [String]
    def initialize(tag_id)
      super(:get, "api/tag/#{tag_id}")
    end

  end

end
