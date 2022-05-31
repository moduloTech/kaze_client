# frozen_string_literal: true

module KazeClient
  # @author ciappa_m@modulotech.fr
  # List the jobs assigned to the current user's company.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class JobsRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest

    def initialize
      super(:get, "api/jobs")
    end
  end
end
