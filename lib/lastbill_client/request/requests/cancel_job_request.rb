# frozen_string_literal: true

module KazeClient
  # @author chevre_a@modulotech.fr
  # Cancel a job.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class CancelJobRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(job_id, cancel_reason_id)
      super(:put, "api/jobs/#{job_id}/cancel")

      @body = {
        job: { cancel_reason_id: cancel_reason_id }
      }
    end
  end
end
