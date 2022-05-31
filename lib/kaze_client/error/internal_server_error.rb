# frozen_string_literal: true

module KazeClient
  module Error
    # @author ciappa_m@modulotech.fr
    # Generic 500 error sent by Kaze server
    class InternalServerError < Generic
      def initialize(msg = "An unknown error occured")
        super(message: msg)
      end
    end
  end
end
