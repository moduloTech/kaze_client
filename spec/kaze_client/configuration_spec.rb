# frozen_string_literal: true

RSpec.describe KazeClient::Configuration do
  after { KazeClient.reset_configuration! }

  describe 'KazeClient.configure' do
    it 'yields the configuration object' do
      KazeClient.configure do |config|
        expect(config).to be(KazeClient.configuration)
      end
    end

    it 'stores configured headers' do
      KazeClient.configure do |config|
        config.headers['X-Api-Key'] = 'my-api-key'
      end

      expect(KazeClient.configuration.headers).to eq('X-Api-Key' => 'my-api-key')
    end
  end

  describe 'header injection on requests' do
    let(:request) { KazeClient::Request.new(:get, '/api/companies') }

    before do
      KazeClient.configure do |config|
        config.headers['X-Api-Key'] = 'my-api-key'
      end
    end

    it 'adds the configured headers to every request' do
      expect(request.parameters[:headers]).to include(
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json',
        'X-Api-Key'    => 'my-api-key'
      )
    end

    it 'lets per-request headers override the configured ones' do
      request.headers['X-Api-Key'] = 'overridden'

      expect(request.parameters[:headers]).to include('X-Api-Key' => 'overridden')
    end
  end

  describe 'KazeClient.reset_configuration!' do
    it 'clears previously configured headers' do
      KazeClient.configure { |config| config.headers['X-Api-Key'] = 'my-api-key' }

      KazeClient.reset_configuration!

      expect(KazeClient.configuration.headers).to be_empty
    end
  end
end
