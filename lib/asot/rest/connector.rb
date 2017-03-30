require 'savon'
require 'rest-client'
require 'asot/rest/data_transformer'

module Asot
  module Rest
    API_VERSION = 38
    REST_PATH = format('/services/data/v%.1f', API_VERSION).freeze

    # salesforce connector. this get access token via partner api.
    class Connector
      include DataTransformer

      # login_config is hash has these symbol keys. endpoint, username, password, security_token
      def initialize(login_config)
        response = login_to_salesforce(login_config)
        keep_connection_info(response.body[:login_response][:result])
        @delete_datas = []
      end

      def add_clean_data(obj, id)
        @delete_datas.push(Target.new(obj, id))
      end

      def do_clean?
        !@delete_datas.empty?
      end

      def clean_testdata
        batches = transform_delete_batch(@delete_datas)
        res = do_post('composite/batch', { batchRequests: batches }.to_json)
        res.body
      end

      def retrieve_record(sobject, id)
        res = do_get("sobjects/#{sobject}/#{id}")
        res.body
      end

      private

        def login_to_salesforce(config)
          wsdl = File.expand_path('../../wsdl/partner.wsdl', __FILE__)
          client = Savon.client(wsdl: wsdl, endpoint: config[:endpoint])
          client.call(
            :login,
            message: {
              username: config[:username],
              password: "#{config[:password]}#{config[:security_token]}"
            }
          )
        end

        def keep_connection_info(res)
          @session_id = res[:session_id]
          @server_url = res[:server_url]
          keep_server_instance
        end

        def keep_server_instance
          urls = @server_url.split('/')
          @server_instance = [urls[0], '//', urls[2]].join
        end

        def do_get(resource_path)
          header = request_header.update('If-Modified-Since' => 'Tue, 1 Jun 2017 12:00:00 GMT')
          RestClient.get "#{@server_instance}#{REST_PATH}/#{resource_path}", header
        end

        def do_post(resource_path, data)
          header = request_header.update('Content-Type' => 'application/json')
          begin
            RestClient.post "#{@server_instance}#{REST_PATH}/#{resource_path}", data, header
          rescue RestClient::ExceptionWithResponse => e
            e.response
          end
        end

        def request_header
          { Authorization: "Bearer #{@session_id}" }
        end
    end
  end
end
