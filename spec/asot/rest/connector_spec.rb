require 'spec_helper'

RSpec.describe Asot::Rest::Connector do
  # mock savon
  let(:client) { spy('Savon Client') }
  let(:login_response) { double('Savon Call Response') }
  let(:connection_info) do
    {
      login_response: {
        result: {
          session_id: 'test_id',
          server_url: 'http://server.com/path'
        }
      }
    }
  end

  before do
    expect(Savon).to receive(:client).and_return(client)
    expect(client).to receive(:call).with(:login, anything).and_return(login_response)
    expect(login_response).to receive(:body).and_return(connection_info)
  end

  subject(:connector) do
    config = {
      endpoint: 'dummy', username: 'dummy', password: 'dummy', security_token: 'dummy'
    }
    Asot::Rest::Connector.new(config)
  end

  # start test
  describe 'initialize' do
    it 'is assign connection info' do
      expect(subject.instance_variable_get(:@session_id)).to eq('test_id')
      expect(subject.instance_variable_get(:@server_url)).to eq('http://server.com/path')
      expect(subject.instance_variable_get(:@server_instance)).to eq('http://server.com')
    end
  end

  describe 'do_clean? data' do
    context 'not exist clean data' do
      it 'is return false' do
        expect(connector.do_clean?).to be_falsey
      end
    end

    context 'exist clean data' do
      it 'is return false' do
        connector.add_clean_data('obj', 'id')
        expect(connector.do_clean?).to be_truthy
      end
    end
  end

  describe 'clean_testdata' do
    let(:ret) { Object.new }

    context 'valid response' do
      before do
        def ret.body() 'response body' end
        expect(RestClient).to receive(:post).and_return(ret)
      end

      it 'return rest-client body' do
        expect(subject.clean_testdata).to eq('response body')
      end
    end

    context 'invalid response' do
      before do
        def ret.body() 'error response' end
        e = RestClient::ExceptionWithResponse.new(ret)
        expect(RestClient).to receive(:post).and_raise(e)
      end

      it 'return rest-client body' do
        expect(subject.clean_testdata).to eq('error response')
      end
    end
  end
end
