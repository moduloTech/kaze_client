# frozen_string_literal: true

module LastbillClient
  module Error
    # @author ciappa_m@modulotech.fr
    # 403 error sent by Lastbill server when trying to log in and user has no token
    class NoPrivateToken < Forbidden
      def initialize(msg = "User has no private token assigned")
        super(msg)
      end
    end
  end
end
