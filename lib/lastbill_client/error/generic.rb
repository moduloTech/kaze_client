# frozen_string_literal: true

module LastbillClient
  # @since 0.1.0
  module Error
    # @author ciappa_m@modulotech.fr
    # Generic error raised when Lastbill server send an unknown error. By default, it is considered
    # to be an internal server error.
    class Generic < RuntimeError
      # @return [Symbol] The HTTP status sent by the server
      attr_reader :status

      # @return [String] if the server sent a custom error code
      # @return [Symbol] if the server sent no code, it is the HTTP status sent by the server
      attr_reader :error

      # The default error message
      DEFAULT_MESSAGE = "An unknown error occured"

      def initialize(status: :internal_server_error, error: nil,
                     message: DEFAULT_MESSAGE)
        super(message || DEFAULT_MESSAGE)

        @status = status || :internal_server_error
        @error  = error || @status
      end
    end
  end
end
