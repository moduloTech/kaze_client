# frozen_string_literal: true

module KazeClient
  module Error
    # @author ciappa_m@modulotech.fr
    # Generic 401 error sent by Kaze server
    class Unauthorized < Generic
      def initialize(msg = "401 Unauthorized")
        super(status: :unauthorized, message: msg)
      end
    end
  end
end
