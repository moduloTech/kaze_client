# frozen_string_literal: true

module KazeClient

    # @author CHEVREUX Alexis
    # Change job supervisor
    #
    # @example
    #     rq = KazeClient::ChangeSupervisorsRequest.new(job_id, [supervisor_id,...]).with_token('token')
    #     KazeClient::Client.new('https://kaze.modulotech.fr').execute(rq)
    #
    # @see KazeClient::Request
    # @see KazeClient::Utils::FinalRequest
    # @see KazeClient::Utils::AuthentifiedRequest
    class ChangeSupervisorsRequest < Utils::FinalRequest
  
      include Utils::AuthentifiedRequest
  
      def initialize(job_id, supervisor_ids)
        super(:put, "/api/job/#{job_id}/supervisor_users")
  
        @body = { supervisor_user_ids: supervisor_ids }
      end
  
    end
  
  end
  