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

    def respond_to_missing?(method_name, include_private=false)
      %i[original_response parsed_response].include?(method_name) || super
    end

    # Find the child whose id is the given one in this response
    #
    # @param id [String] The id of the child to find
    # @return [Hash,nil] The child or nil if not found
    # @see KazeClient::JsonUtils.fetch_node
    def fetch_child(id)
      ::KazeClient::JsonUtils.fetch_node(self, %{$..children[?(@['id'] == '#{id}')]})
    end

    # Find the first child with the given id and return the given field
    #
    # @param id [String] The id of the child to find
    # @param field [String] The name of the searched field
    # @return [Object,nil] The value of the field or nil if not found
    # @see #fetch_child
    def fetch_data_from_child(id, field: 'data')
      fetch_child(id)&.[](field)
    end

    # Find all the widget in this response.
    # Technically, it fetch all the children whose type is +widget_*+
    #
    # @return [Array] The list of widgets
    # @see KazeClient::JsonUtils.fetch_nodes
    def fetch_widgets
      ::KazeClient::JsonUtils.fetch_nodes(self, %{$..children[?(@['type'] =~ /^widget_/)]})
    end

    # Find the first child with the given id and update value of the given field
    # Does nothing when +id+ was not found.
    # Add a field when +field+ is not found.
    #
    # @param id [String] The id of the child to find
    # @param value [Object] The value to set on the field
    # @param field [String] The name of the searched field
    # @return [KazeClient::Response] The response itself for chaining
    # @see #fetch_child
    def update_data_in_child(id, value, field: 'data')
      fetch_child(id)&.[]=(field.to_s, value)

      self
    end

  end

end
