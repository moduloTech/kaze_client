# frozen_string_literal: true

module LastbillClient
  # @author ciappa_m@modulotech.fr
  # Request the list of companies.
  # @see LastbillClient::Request
  # @see LastbillClient::Utils::FinalRequest
  # @see LastbillClient::Utils::AuthentifiedRequest
  # @see LastbillClient::Utils::ListRequest
  # @since 0.1.0
  class CompaniesRequest < Utils::FinalRequest
    include Utils::AuthentifiedRequest
    include Utils::ListRequest

    def initialize
      super(:get, "api/companies")
    end
  end
end