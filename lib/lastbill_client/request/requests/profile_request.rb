# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Request data about the current user.
  # @see LastbillClient::Request
  # @see LastbillClient::Utils::FinalRequest
  # @see LastbillClient::Utils::AuthentifiedRequest
  # @since 0.1.0
  class ProfileRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest

    def initialize
      super(:get, "api/profile")
    end
  end
end
