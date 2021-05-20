# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Fetch the details for the given job id.
  # @see LastbillClient::Request
  # @see LastbillClient::Utils::FinalRequest
  # @see LastbillClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class JobRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(id)
      super(:get, "api/jobs/#{id}")
    end
  end
end
