# frozen_string_literal: true

module KazeClient

  # @author pourch_t@modulotech.fr
  # @author ciappa_m@modulotech.fr
  # Upload an image to a job document from a job.
  # @see KazeClient::Request
  # @see KazeClient::Utils::FinalRequest
  # @see KazeClient::Utils::AuthentifiedRequest
  # @since 0.3.0
  # @example How to use
  #   request  = KazeClient::UploadImageRequest.new(Rails.root.join('public/images/test.jpg'))
  #   response = KazeClient::Client.new(URL).execute(request)
  #   request.send_image(response['direct_upload'])
  class UploadImageRequest < Utils::FinalRequest

    include Utils::AuthentifiedRequest

    def initialize(filepath)
      super(:post, 'api/direct_uploads')

      @filepath = filepath.is_a?(Pathname) ? filepath : Pathname.new(filepath.to_s)
      @filename = @filepath.basename.to_s

      @body = {
        blob: {
          filename: @filename, byte_size: File.size(@filepath),
          checksum: Digest::MD5.base64digest(@filepath.read),
          content_type: "image/#{@filename.split('.')[1]}"
        }
      }
    end

    def send_image(direct_uploads)
      body   = @filepath.read
      header = direct_uploads['headers']
      HTTParty.put(direct_uploads['url'], { body: body, headers: header })
    end

  end

end
