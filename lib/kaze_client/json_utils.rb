# frozen_string_literal: true

module KazeClient

  # @author ciappa_m@modulotech.fr
  # Utility methods to interact with JSON data
  # @see KazeClient::Response
  # @since 0.2.1
  module JsonUtils

    # Fetch nodes in given JSON
    #
    # @param json [KazeClient::Response,Hash,String] The JSON to analyze
    # @param path [String] A JSONpath - https://goessner.net/articles/JsonPath/
    # @return [Array] The nodes or data corresponding to the path
    def self.fetch_nodes(json, path)
      json = case json
             when ::KazeClient::Response
               json.parsed_response
             when String
               JSON.parse(json)
             else
               json
             end

      JsonPath.on(json, path)
    end

    # Fetch a node in given JSON
    #
    # @param json [KazeClient::Response,Hash,String] The JSON to analyze
    # @param path [String] A JSONpath - https://goessner.net/articles/JsonPath/
    # @return [Object,nil] The node or data corresponding to the path or nil
    def self.fetch_node(json, path)
      fetch_nodes(json, path).first
    end

  end

end
