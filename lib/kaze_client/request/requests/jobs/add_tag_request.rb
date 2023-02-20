# frozen_string_literal: true

module KazeClient
  # @author RICHARD Peter <richar_p@modulotech.fr>
  # KazeClient request to add tags to a job
  # @note    This request is for the moment in re-development. It is not working well.
  #          When you add a tag with it, it doesnt check if the id is correct or not and it delete all the other tags
  #          It will be fixed in the next version of Kaze API, but for now, we use it like that
  #
  # @example
  #     rq = KazeClient::AddTagRequest.new(123, [1, 2, 3]).with_token('token')
  #     KazeClient::Client.new('https://kaze.modulotech.fr').execute(rq)
  # Will make a request like this:
  #    PUT https://kaze.modulotech.fr/api/tags/references/job/123.json
  #   --- HEADERS ---
  #   {
  #       "Authorization": "token"
  #   }
  #   --- BODY ---
  #   {
  #       "tags": [1, 2, 3]
  #   }
  # @return [KazeClient::Response] The response of the request
  # @since 0.4.0
  class AddTagRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize(job_id, tag_ids)
      super(:put, "/api/tags/references/job/#{job_id}.json")
      @body = { tags: tag_ids }
    end
  end
end
