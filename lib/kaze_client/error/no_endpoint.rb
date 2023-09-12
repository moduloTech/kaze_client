# frozen_string_literal: true

module KazeClient

  module Error

    # @author ciappa_m@modulotech.fr
    # An error raised when the base URL given to the +KazeClient::Client+ is nil
    # @see KazeClient::Client
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
