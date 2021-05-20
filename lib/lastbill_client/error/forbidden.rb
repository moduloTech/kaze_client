# frozen_string_literal: true

module LastbillClient
  module Error
    # @author ciappa_m@modulotech.fr
    # Generic 403 error sent by Lastbill server
    class Forbidden < Generic
      def initialize(msg = "403 Forbidden")
        super(status: :forbidden, message: msg)
      end
    end
  end
end
