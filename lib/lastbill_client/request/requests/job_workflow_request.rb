# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Request the details about a specific workflow.
  # @see LastbillClient::Request
  # @see LastbillClient::Utils::FinalRequest
  # @see LastbillClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class JobWorkflowRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    # @return [String] The id of the workflow to request
    attr_reader :id

    # @param id [String] Set the id of the workflow to request
    def initialize(id)
      super(:get, "api/job_workflows/#{id}")

      @id      = id
      @query   = {}
      @filters = {}
    end
  end
end
