# frozen_string_literal: true

module LastbillClient
  module Error
    # @author ciappa_m@modulotech.fr
    # An error raised when the base URL given to the +LastbillClient::Client+ is nil
    # @see LastbillClient::Client
    class NoEndpoint < Generic
      # @return the given base URL
      attr_reader :base_url

      def initialize(base_url)
        super(status: nil, message: "Invalid base url +#{base_url}+", error: nil)

        @base_url = base_url
      end
    end
  end
end
