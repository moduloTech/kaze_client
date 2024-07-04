# frozen_string_literal: true

module KazeClient

  # @author bourda_c@modulotech.fr
  # Update a given job cell.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.4.1
  class UpdateJobCellRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @return [String] The id of the target job.
    attr_reader :job_id

    # @return [String] The id of the target cell.
    attr_reader :cell_id

    # @return [Hash] The workflow used to update the cell.
    attr_reader :cell_data

    def initialize(job_id, cell_id, cell_data, skip_version_check: false)
      super(:put, "api/jobs/#{job_id}/cells/#{cell_id}")

      @body = {
        data:               {
          cell_id => cell_data
        },
        skip_version_check: skip_version_check ? 1 : 0
      }
    end

  end

end
