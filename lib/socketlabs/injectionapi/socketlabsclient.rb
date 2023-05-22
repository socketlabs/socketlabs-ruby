require 'net/http'
require_relative '../version.rb'
require_relative 'send_response.rb'
require_relative 'send_result.rb'
require_relative 'message/message_base.rb'
require_relative 'message/basic_message.rb'
require_relative 'message/bulk_message.rb'
require_relative 'core/injection_request_factory.rb'
require_relative 'core/http_request.rb'
require_relative 'core/retryhandler.rb'
require_relative 'retrysettings.rb'

module SocketLabs
  module InjectionApi
    class SocketLabsClient
      include SocketLabs::InjectionApi::Core
      include SocketLabs::InjectionApi::Message

      public
      attr_reader :request_json
      attr_reader :response_json

      def initialize (
          server_id,
          api_key,
          proxy= {}
      )
        @server_id = server_id
        @api_key = api_key
        @proxy = proxy
        @endpoint = "https://inject.socketlabs.com/api/v1/email"
        @request_timeout = 120
        @number_of_retries = 0
      end

      # Sends a Message message and returns the response from the Injection API.
      # @param [BasicMessage, BulkMessage] message: A Message object to be sent.
      # @return [SendResponse] the SendResponse from the request
      def send(message)

        response = SendResponse.new

        if message.instance_of? BasicMessage
          response = send_basic_message(message)
        end

        if message.instance_of? BulkMessage
          response = send_bulk_message(message)
        end

        response

      end

      def to_s
        "#{@endpoint}::#{@server_id}:#{@api_key}"
      end

      private
      # Your SocketLabs ServerId number.
      attr_accessor :server_id
      # Your SocketLabs Injection API key.
      attr_accessor :api_key
      # The Proxy you would like to use.
      attr_accessor :proxy
      # The SocketLabs Injection API endpoint Url
      attr_accessor :endpoint

      public
      # The SocketLabs Injection API Request Timeout
      attr_accessor :request_timeout
      attr_accessor :number_of_retries

      def http_method
        HttpRequest.http_request_method[:Post]
      end

      # Sends a BasicMessage message and returns the response from the Injection API.
      # @param [BasicMessage] message: A BasicMessage object to be sent.
      # @return [SendResponse] the SendResponse from the request
      def send_basic_message(message)

        resp = validate_message(message)
        if resp.result != SendResult.enum["Success"]
          resp
        end

        req_factory = InjectionRequestFactory.new(@server_id, @api_key)
        request = req_factory.generate_request(message)

        # debug
        request_hash = request.to_hash
        debug_json = request_hash.to_json
        @request_json = debug_json

        apiKeyParser = ApiKeyParser.new()
        parseResult = apiKeyParser.parse(@api_key);

        httpArguments = {
          :http_endpoint => @endpoint,
          :proxy => @proxy,
          :timeout => @request_timeout,
          :authorization => ''
        }
        if parseResult == ApiKeyParseResult.enum["Success"]
          httpArguments[:authorization] = @api_key
          request.api_key = ''
        end

        http_request = HttpRequest.new(http_method, httpArguments)

        retry_handler = RetryHandler.new(http_request, @endpoint, RetrySettings.new(@number_of_retries))
        response = retry_handler.send(request)

        parser = InjectionResponseParser.new
        result = parser.parse(response)

        @response_json = result.to_json

      end

      # Sends a BulkMessage message and returns the response from the Injection API.
      # @param [BulkMessage] message: A BulkMessage object to be sent.
      # @return [SendResponse] the SendResponse from the request
      def send_bulk_message(message)

        resp = validate_message(message)
        if resp.result != SendResult.enum["Success"]
          resp
        end

        req_factory = InjectionRequestFactory.new(@server_id, @api_key)
        request = req_factory.generate_request(message)

        # debug
        request_hash = request.to_hash
        debug_json = request_hash.to_json
        @request_json = debug_json

        http_request = HttpRequest.new(http_method, { :http_endpoint => @endpoint, :proxy => @proxy, :timeout => @request_timeout })
        retry_handler = RetryHandler.new(http_request, @endpoint, RetrySettings.new(@number_of_retries))
        response = retry_handler.send(request)

        parser = InjectionResponseParser.new
        result = parser.parse(response)

        @response_json = result.to_json

      end

      # Validate a BulkMessage message
      # @param [MessageBase] message
      # @return [SendResult]
      def validate_message(message)
        validator = SendValidator.new
        resp = validator.validate_credentials(@server_id, @api_key)
        if resp.result != SendResult.enum["Success"]
          resp
        end
        validator.validate_message(message)
      end

    end
  end
end