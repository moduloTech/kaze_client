# frozen_string_literal: true

module KazeClient
  # @author ciappa_m@modulotech.fr
  # Request the list of job workflows for the current user.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @see KazeClient::Utils::ListRequest
  # @since 0.1.0
  class JobWorkflowsRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest

    def initialize
      super(:get, 'api/job_workflows')
    end
  end
end
