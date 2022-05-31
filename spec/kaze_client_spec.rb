# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe KazeClient do
  it 'has a version number' do
    expect(KazeClient::VERSION).not_to be nil
  end

  describe 'error handling' do
    let(:client) { KazeClient::Client.new('https://staging.lastbill.co') }

    it 'raises a Not Found error on unknown API' do
      request = KazeClient::Request.new(:post, '/login')

      expect { client.execute(request) }.to raise_error(KazeClient::Error::NotFound, '404 Not Found')
    end

    it 'raises an Invalid Credentials error on bad credentials at login' do
      request = KazeClient::LoginRequest.new(login: 'login', password: 'password')

      expect { client.execute(request) }.to raise_error(KazeClient::Error::InvalidCredentials)
    end

    it 'raises an Invalid Credentials error on bad credentials at login' do
      request = KazeClient::PartnersRequest.new

      expect { client.execute(request) }.to raise_error(KazeClient::Error::Unauthorized)
    end
  end

  describe 'login request' do
    let(:client) { KazeClient::Client.new('https://staging.lastbill.co') }

    it 'responds with success on valid credentials' do
      request = KazeClient::LoginRequest.new(login: 'test@test.test', password: 'password')

      response = client.execute(request)

      # Expect to get a valid KazeClient::Response
      expect(response).to be_a_kind_of(KazeClient::Response)
      # Have to check for the body not to be nil since  HTTParty will no longer override
      # +response#nil?+. For more info refer to: https://github.com/jnunemaker/httparty/issues/568
      expect(response.original_response.body).not_to be_nil
      expect(response.parsed_response).not_to be_nil

      token_on_parsed_response = response.parsed_response['token']
      token_on_response        = response['token']

      # Expect to get token on the response
      expect(token_on_parsed_response).to be_a_kind_of(String)
      expect(token_on_response).to be_a_kind_of(String)

      # Expect the delegation from response to parsed_response to work
      expect(token_on_response).to eq(token_on_parsed_response)
    end
  end

  describe 'authentified requests' do
    let(:client) { KazeClient::Client.new('https://staging.lastbill.co') }
    let(:auth_token) do
      request = KazeClient::LoginRequest.new(login: 'test@test.test', password: 'password')

      response = client.execute(request)

      response['token']
    end

    it 'responds with success on profile request with given token' do
      request = KazeClient::ProfileRequest.new.with_token(auth_token)

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end

    it 'raises InvalidCredentials on profile request without token nor initial login' do
      request = KazeClient::ProfileRequest.new

      expect { client.execute(request) }.to(
        raise_error(KazeClient::Error::InvalidCredentials, 'Please set login and password')
      )
    end

    it 'responds with success on profile request with initial login' do
      client.login('test@test.test', 'password')

      request = KazeClient::ProfileRequest.new

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end
  end

  describe 'list requests' do
    let(:client) do
      client = KazeClient::Client.new('https://staging.lastbill.co')

      client.login('test@test.test', 'password')

      client
    end

    it 'applies metadata with success on companies request' do
      # On /api/companies, default parameters are:
      #   - page: 1
      #   - per_page: 100
      #   - order_field: name
      #   - order_direction: asc
      #   - filters: {}
      # The goal here is just to get those metadata in the response. We do not care if pagination,
      # sorting and filtering were applied. We are not here to test the server's implementation.
      # For instance, +target_id+ is not even a field on /api/companies data.
      request = KazeClient::PartnersRequest.new
                                           .add_page(5)
                                           .add_per_page(42)
                                           .add_order_field('id')
                                           .add_order_direction(:desc)
                                           .filter_by_id('a')
                                           .filter_by_email('a')

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('meta', 'page')).to eq(5)
      expect(response.dig('meta', 'per_page')).to eq(42)
      expect(response.dig('meta', 'order_field')).to eq('id')
      expect(response.dig('meta', 'order_direction')).to eq('desc')
      expect(response.dig('meta', 'filter', 'id')).to eq('a')
      expect(response.dig('meta', 'filter', 'email')).to eq(%w[a])
    end
  end

  describe 'jobs requests' do
    let(:client) do
      client = KazeClient::Client.new('https://staging.lastbill.co')

      client.login('test@test.test', 'password')

      client
    end

    it 'gets the list of the jobs' do
      request = KazeClient::JobsRequest.new

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response['data']).to be_a_kind_of(Array)
      expect(response['data'].first).not_to be_nil
    end

    it 'gets the details of the job' do
      request = KazeClient::JobRequest.new('ee33d67a-3211-4781-b589-4b76d1bb7462')

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response['id']).to eq('ee33d67a-3211-4781-b589-4b76d1bb7462')
    end
  end
end
# rubocop:enable Metrics/BlockLength
