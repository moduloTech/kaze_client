# frozen_string_literal: true

module KazeClient
  # @author chevre_a@modulotech.fr
  # Upload an ActiveStorage::Attachment to a job document from a job.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.0
  # @example How to use
  #   rq = KazeClient::UploadImageRequest.new(f).with_token(TOKEN)
  #   response = KazeClient::Client.new(URL).execute(rq)
  #   rq.send_attachment(response['direct_upload'])
  class UploadAttachmentRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    # @param attachment [ActiveStorage::Attachment]
    def initialize(attachment)
      super(:post, 'api/direct_uploads')

      # @type [ActiveStorage::Attachment]
      @attachment = attachment

      @body = {
        blob: {
          filename:     @attachment.filename,
          byte_size:    @attachment.byte_size,
          checksum:     @attachment.checksum,
          content_type: @attachment.content_type
        }
      }
    end

    def send_attachment(direct_uploads)
      header = direct_uploads['headers']
      HTTParty.put(direct_uploads['url'], { body: @attachment.download, headers: header })
    end

  end

end
