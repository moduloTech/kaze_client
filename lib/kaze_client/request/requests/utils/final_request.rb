# frozen_string_literal: true

module KazeClient
  module Utils
    # @author ciappa_m@modulotech.fr
    # Set the request as final, disabling the edition of query parameters, headers and request body.
    # @see KazeClient::Request
    class FinalRequest < Request
      # Remove write access inherited from Request
      undef_method :query=, :body=, :headers=
    end
  end
end
