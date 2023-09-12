# frozen_string_literal: true

module KazeClient

  module Error

    # @author ciappa_m@modulotech.fr
    # 403 error sent by Kaze server when trying to log in and user has no token
    class NoPrivateToken < Forbidden

      def initialize(msg='User has no private token assigned')
        super(msg)
      end

    end

  end

end
