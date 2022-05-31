# frozen_string_literal: true

module KazeClient
  module Error
    # @author ciappa_m@modulotech.fr
    # 401 error sent by Kaze server when trying to log in with invalid credentials
    class InvalidCredentials < Unauthorized
      def initialize(msg = 'Invalid Login or Password')
        super(msg)
      end
    end
  end
end
