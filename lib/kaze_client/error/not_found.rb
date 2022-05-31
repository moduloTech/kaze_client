# frozen_string_literal: true

module KazeClient
  module Error
    # @author ciappa_m@modulotech.fr
    # 404 error sent by Kaze server
    class NotFound < Generic
      def initialize(msg = "404 Not Found")
        super(status: :not_found, message: msg)
      end
    end
  end
end
