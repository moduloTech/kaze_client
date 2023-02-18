# frozen_string_literal: true

module KazeClient
  # @author richar_p@modulotech.fr
  # Utility methods to interact with KazeData
  # @since 0.3.2
  module DataUtils
    # Parse a Kaze Workflow datetime
    # @param time [Integer] The datetime to parse
    # @return [Time] The parsed datetime
    # @example
    #  KazeClient::DataUtils.parse_datetime(1546300800000)
    # => 2019-01-01 00:00:00 UTC
    def self.parse_time(time)
      raise ArgumentError, 'time must not be nil' unless time.nil?

      Time.at(time.to_i / 1000).utc
    end
  end
end
