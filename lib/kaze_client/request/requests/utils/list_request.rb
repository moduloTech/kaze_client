# frozen_string_literal: true

module KazeClient

  module Utils

    # @author ciappa_m@modulotech.fr
    # Included by the request where a list will be returned.
    # @see KazeClient::Request
    module ListRequest

      # @return [Integer,String] The page to fetch.
      attr_reader :page

      # @return [Integer] The number of items to fetch by page; between 1 and 100.
      attr_reader :per_page

      # @return [String] The field to use for the list order.
      attr_reader :order_field

      # @return ['asc', 'desc'] The direction of the order.
      attr_reader :order_direction

      # @return [Hash] The filters to apply to the query.
      attr_reader :filters

      def initialize(method, url)
        super(method, url)

        @query   ||= {}
        @filters ||= {}
      end

      # @param page [Integer,String] Set the page to fetch
      # @return [KazeClient::Utils::ListRequest] self (to chain methods)
      def add_page(page)
        # Ensure the +per_page+ parameter is valid; default is 1
        @page = if !page.is_a?(Numeric) || page.to_i < 1
                  1
                else
                  page
                end

        @query[:page] = @page

        self
      end

      # @param per_page [Integer,String] Set the number of items to fetch per page
      # @return [KazeClient::Utils::ListRequest] self (to chain methods)
      def add_per_page(per_page)
        # Ensure the +per_page+ parameter is between 1 and 100
        @per_page = if !per_page.is_a?(Numeric) || per_page.to_i < 1
                      1
                    else
                      [per_page, 100].min
                    end

        @query[:per_page] = @per_page

        self
      end

      # @param field [String] Set the field to use for the list order
      # @return [KazeClient::Utils::ListRequest] self (to chain methods)
      def add_order_field(field)
        @order_field         = field
        @query[:order_field] = @order_field

        self
      end

      # @param direction ['asc','desc'] Set the direction of the order.
      # @return [KazeClient::Utils::ListRequest] self (to chain methods)
      def add_order_direction(direction)
        # Ensure the +direction+ parameter is valid; default direction is ascendant
        @order_direction = %w[asc desc].include?(direction.to_s) ? direction.to_s : 'asc'

        @query[:order_direction] = @order_direction

        self
      end

      # @!method filter_by_id(value)
      #   This is an example. Any method beginning with +filter_by_+ is valid and defined using
      #   +method_missing+. This adds a filter on the string following +filter_by_+ to the query.
      #   @param value [String] Add a filter to the query.
      #   @return [KazeClient::Utils::ListRequest] self (to chain methods)
      #   @example To filter on id then on name
      #     filter_by_id(2).filter_by_name('foo')
      def method_missing(method_name, *args, &block)
        match_data = method_name.match(/^filter_by_(\w+)/)

        # Match_data[0] is the whole match while match_data[1] is the first capture group; here
        # it is the field to filter on.
        # Only the first given argument is considered to be the value to filter on. Possible
        # subsequent arguments are ignored.
        match_data ? filter_by(match_data[1], args[0]) : super
      end

      def respond_to_missing?(method_name, include_private=false)
        method_name.match?(/^filter_by_/) || super
      end

      private

      def filter_by(field, value)
        # Initialize the filters Hash if needed
        # @filters ||= {}

        # Store the filter
        @filters[field] = value

        # Set the filter on the query parameters
        @query["filter[#{field}]"] = value

        self
      end

    end

  end

end
