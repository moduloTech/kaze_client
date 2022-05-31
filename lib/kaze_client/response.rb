# frozen_string_literal: true

module KazeClient
  # @author ciappa_m@modulotech.fr
  # Represents response from a Kaze API
  # @see KazeClient::Client
  # @see KazeClient::Request
  # @since 0.1.0
  class Response
    # @return [HTTParty::Response] The response object from HTTParty call
    attr_reader :original_response

    # @return [Hash] The JSON object resulting from HTTParty parsed response
    attr_reader :parsed_response

    # @param response [HTTParty::Response] The response object from HTTParty call
    def initialize(response)
      @original_response = response
      @parsed_response   = response.parsed_response
    end

    def method_missing(method_name, *args, &block)
      if %i[original_response parsed_response].include?(method_name)
        send(method_name)
      else
        @parsed_response.send(method_name, *args, &block)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      %i[original_response parsed_response].include?(method_name) || super
    end
  end
end
