# frozen_string_literal: true

module KazeClient
  # @author ciappa_m@modulotech.fr
  # Update data of the given template on the given job.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class UpdateTemplateRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(id, template_id, body)
      super(:put, "api/performer/jobs/#{id}/templates/#{template_id}")

      @body = body
    end
  end
end
