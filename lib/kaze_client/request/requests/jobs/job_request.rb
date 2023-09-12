# frozen_string_literal: true

module KazeClient

  # @author ciappa_m@modulotech.fr
  # Fetch the details for the given job id.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class JobRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    def initialize(id)
      super(:get, "api/jobs/#{id}")
    end

  end

end
