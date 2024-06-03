# frozen_string_literal: true

module KazeClient

  # @author bourda_c@modulotech.fr
  # Create a job from the current user to the job workflow
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.1
  class CreateJobFromWorkflowRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @return [String] The id of the target workflow.
    attr_reader :workflow_id

    # @return [Hash] The workflow used to create the job.
    attr_reader :job_workflow

    # @param workflow_id [String] The id of the target job Workflow.
    # @param job_workflow [Hash] The workflow to use to create the job.
    def initialize(workflow_id, job_workflow, target_id, performer_user_id)
      super(:post, "api/job_workflows/#{workflow_id}/job.json")

      @job_workflow = job_workflow
      @body = {
        target_id:         target_id,
        performer_user_id: performer_user_id,
        data:              @job_workflow
      }
    end

  end

end
