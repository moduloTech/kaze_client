# frozen_string_literal: true

module LastbillClient
  # @since 0.1.0
  module Utils
    # @author ciappa_m@modulotech.fr
    # Included by the request where an authentication token is required.
    # @see LastbillClient::Request
    module AuthentifiedRequest
      # @return [String] The authentication token
      attr_reader :token

      # Store the given authentication token and use it to set the +Authorization+ header of the
      # request.
      # @param token [String] The authentication token
      # @return [LastbillClient::Utils::AuthentifiedRequest] self (to chain methods)
      def with_token(token)
        @token                    = token
        @headers["Authorization"] = token

        self
      end
    end
  end
end
