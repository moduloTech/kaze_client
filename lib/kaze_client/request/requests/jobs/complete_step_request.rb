# frozen_string_literal: true

module KazeClient

  # @author richar_p@modulotech.fr
  # Validate a step from a job.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.3
  class CompleteStepRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @return [String] The id of the targeted job.
    attr_reader :job_id

    # @return [Hash] The step needed to be completed.
    attr_reader :step_id

    # @example
    # KazeClient::CompleteStepRequest.new('5295d1c4-2c25-4fc2-8bad-e714f2907f0d', 'job_info')
    # => The step job_info is now completed.
    def initialize(job_id, step_id)
      super(:put, "api/jobs/#{job_id}/cells/#{step_id}")

      @body = {
        data: {
          step_id => { completed: { value: true } }
        }
      }
    end

  end

end
