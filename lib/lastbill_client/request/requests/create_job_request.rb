# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Create a job from the current user to the target company.
  # @see LastbillClient::Request
  # @see LastbillClient::Utils::FinalRequest
  # @see LastbillClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class CreateJobRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    # @return [String] The id of the target company.
    attr_reader :target_id

    # @return [Hash] The workflow used to create the job.
    attr_reader :workflow

    # @param target_id [String] The id of the target company.
    # @param workflow [Hash] The workflow to use to create the job.
    def initialize(target_id, workflow)
      super(:post, "api/jobs")

      @target_id = target_id
      @workflow  = workflow
      @body      = {
        target_id: @target_id,
        workflow: @workflow
      }
    end
  end
end
