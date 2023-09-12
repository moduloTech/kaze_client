# frozen_string_literal: true

module KazeClient

  module Error

    # @author ciappa_m@modulotech.fr
    # 403 error sent by Kaze server when trying to log in with a disabled account
    class DisabledAccount < Forbidden

      def initialize(msg='User account was disabled by administrator')
        super(msg)
      end

    end

  end

end
