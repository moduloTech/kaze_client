# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe KazeClient do
  # A fake token: requests are stubbed (see the before block), so its value is never verified.
  let(:auth_token) { 'test-auth-token' }

  let(:base_url) { 'https://staging.kaze.so' }

  # The +Content-Type+ is required: HTTParty only parses the body as JSON when the server
  # announces it, so without it the response stays a raw String.
  let(:json_headers) { { 'Content-Type' => 'application/json' } }

  # Stub every endpoint the suite exercises with a captured (or crafted) response so the tests
  # never hit the real server. WebMock raises on any unstubbed request (see spec_helper).
  before do
    # Unknown API: '/login' resolves to '<base>//login' and the server replies 404.
    stub_request(:post, "#{base_url}//login")
      .to_return(status: 404, headers: json_headers, body: { status: 404, error: 'Not Found' }.to_json)

    # Login with valid credentials returns a token.
    stub_request(:post, "#{base_url}/api/login")
      .with(body: { user: { login: 'test@test.test', password: 'password' } }.to_json)
      .to_return(status: 200, headers: json_headers, body: { token: auth_token }.to_json)

    # Login with invalid credentials is rejected.
    stub_request(:post, "#{base_url}/api/login")
      .with(body: { user: { login: 'login', password: 'password' } }.to_json)
      .to_return(status: 401, headers: json_headers,
                 body: { error: 'invalid_credentials', message: 'Invalid Login or Password' }.to_json)

    stub_request(:get, "#{base_url}/api/profile")
      .to_return(status: 200, headers: json_headers, body: fixture('profile'))

    # /api/companies (partners) echoes the pagination/sorting/filtering metadata back. The query
    # is matched loosely so any combination of list parameters resolves to the same response.
    stub_request(:get, %r{#{base_url}/api/partners}).to_return(
      status:  200,
      headers: json_headers,
      body:    {
        meta: {
          page: 5, per_page: 42, order_field: 'id', order_direction: 'desc',
          filter: { id: 'a', email: %w[a] }, total_pages: 0, total_count: 0
        },
        data: []
      }.to_json
    )

    stub_request(:get, "#{base_url}/api/jobs")
      .to_return(status: 200, headers: json_headers, body: fixture('jobs'))
    stub_request(:get, "#{base_url}/api/jobs/c616f8de-7d7e-4a35-96c9-41c1345a6234")
      .to_return(status: 200, headers: json_headers, body: fixture('job'))
  end

  it 'has a version number' do
    expect(KazeClient::VERSION).not_to be nil
  end

  describe 'error handling' do
    let(:client) { KazeClient::Client.new('https://staging.kaze.so') }

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
    let(:client) { KazeClient::Client.new('https://staging.kaze.so') }

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
    it 'responds with success on profile request with given token' do
      request = KazeClient::ProfileRequest.new.with_token(auth_token)

      client = KazeClient::Client.new('https://staging.kaze.so')
      allow(client).to receive(:login)

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')

      # Since token was given on the request, no login call should have been made
      expect(client).not_to have_received(:login)
    end

    it 'raises InvalidCredentials on profile request without token nor initial login' do
      request = KazeClient::ProfileRequest.new

      client = KazeClient::Client.new('https://staging.kaze.so')
      allow(client).to(receive(:login))
                   .and_raise(KazeClient::Error::InvalidCredentials,
                              'Please set login and password')

      expect { client.execute(request) }.to(
        raise_error(KazeClient::Error::InvalidCredentials, 'Please set login and password')
      )

      # Since token was not given, login call should have been made (and fail since no creds)
      expect(client).to have_received(:login).with(no_args)
    end

    it 'responds with success on profile request with initial login' do
      client = KazeClient::Client.new('https://staging.kaze.so')
      client.login('test@test.test', 'password')

      request = KazeClient::ProfileRequest.new

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end

    it 'responds with success on profile request with credentials already set' do
      client = KazeClient::Client.new('https://staging.kaze.so')
      client.instance_variable_set(:@login, 'test@test.test')
      client.instance_variable_set(:@password, 'password')

      request = KazeClient::ProfileRequest.new

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end

    it 'responds with success on profile request when client is initialized with token' do
      client = KazeClient::Client.new('https://staging.kaze.so', token: auth_token)
      allow(client).to receive(:login)
      request = KazeClient::ProfileRequest.new

      response = client.execute(request)

      # Since token was given, login call should not have been made
      expect(client).not_to have_received(:login)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end

    it 'responds with success on profile request when client is assigned a token' do
      client = KazeClient::Client.new('https://staging.kaze.so').with_token(auth_token)
      allow(client).to receive(:login)
      request = KazeClient::ProfileRequest.new

      response = client.execute(request)

      # Since token was given, login call should not have been made
      expect(client).not_to have_received(:login)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response.dig('user', 'email')).to eq('test@test.test')
    end
  end

  describe 'list requests' do
    let(:client) { KazeClient::Client.new('https://staging.kaze.so', token: auth_token) }

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
    let(:client) { KazeClient::Client.new('https://staging.kaze.so', token: auth_token) }

    it 'gets the list of the jobs' do
      request = KazeClient::JobsRequest.new

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response['data']).to be_a_kind_of(Array)
      expect(response['data'].first).not_to be_nil
    end

    it 'gets the details of the job' do
      request = KazeClient::JobRequest.new('c616f8de-7d7e-4a35-96c9-41c1345a6234')

      response = client.execute(request)

      # Check the response is valid
      expect(response).to be_a_kind_of(KazeClient::Response)
      expect(response['id']).to eq('c616f8de-7d7e-4a35-96c9-41c1345a6234')

      # fetch_child
      widget = response.fetch_child('test_widget_text')
      expect(widget).to be_a_kind_of(Hash)
      expect(widget['type']).to eq('widget_text')

      # fetch_data_from_child
      data = response.fetch_data_from_child('test_widget_text')
      expect(data).to eq('this is a test.')
      access = response.fetch_data_from_child('test_widget_text', field: 'access')
      expect(access).to eq(133)

      # fetch_widgets
      expect(response.fetch_widgets).to eq([widget])

      # update_data_in_child
      response.update_data_in_child('test_widget_text', 'plop')
      response.update_data_in_child('test_widget_text', 666, field: 'access')
      data = response.fetch_data_from_child('test_widget_text')
      expect(data).to eq('plop')
      access = response.fetch_data_from_child('test_widget_text', field: 'access')
      expect(access).to eq(666)
    end
  end

  describe 'json utils' do
    shared_examples 'fetch_node' do
      it 'works' do
        node = ::KazeClient::JsonUtils.fetch_node(json, '$')
        expect(node).to be_a_kind_of(Hash)
        expect(node['a']).to eq('1')

        array = ::KazeClient::JsonUtils.fetch_node(json, '$.c')
        expect(array).to be_a_kind_of(Array)

        array = ::KazeClient::JsonUtils.fetch_nodes(json, '$..c1')
        expect(array).to eq(['1', 2])
      end
    end

    context 'when json is a hash' do
      let(:json) { { 'a' => '1', 'b' => 2, 'c' => [{ 'c1' => '1' }, { 'c1' => 2 }] } }
      include_examples 'fetch_node'
    end

    context 'when json is a string' do
      let(:json) { '{"a":"1","b":2,"c":[{"c1":"1"},{"c1":2}]}' }

      include_examples 'fetch_node'
    end
  end
end
# rubocop:enable Metrics/BlockLength
