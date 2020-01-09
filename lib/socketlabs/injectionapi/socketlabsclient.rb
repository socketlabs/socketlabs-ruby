require 'ruby_http_client'
require_relative '../version.rb'

module SocketLabs
  module InjectionApi
    class SocketLabsClient

      public
      def initialize (
          server_id,
          api_key,
          proxy= nil
      )
        @server_id = server_id
        @api_key = api_key
        @proxy = proxy
      end

      def send(message)
        if message.instance_of? BasicMessage

        end
        if message.instance_of? BulkMessage

        end
      end


      private
      # Your SocketLabs ServerId number.
      attr_accessor :server_id
      # Your SocketLabs Injection API key.
      attr_accessor :api_key
      # The Proxy you would like to use.
      attr_accessor :proxy

      def endpoint
        # HttpEndpoint("inject.socketlabs.com", "/api/v1/email")
      end

      def send_basic_message(message)

        resp = validate_message(message)
        if resp.result != SendResult.enum[:Success]
          resp
        end

        #req_factory = InjectionRequestFactory.new(@server_id, @api_key)
        #body = req_factory.generate_request(message)

      end

      def send_bulk_message(message)

        resp = validate_message(message)
        if resp.result != SendResult.enum[:Success]
          resp
        end

        #req_factory = InjectionRequestFactory.new(@server_id, @api_key)
        #body = req_factory.generate_request(message)

      end

      # Validate a BulkMessage message
      # @param [MessageBase] message
      # @return [SendResult]
      def validate_message(message)
        validator = SendValidator.new
        resp = validator.validate_credentials(@server_id, @api_key)
        if resp.result != SendResult.enum[:Success]
          resp
        end
        validator.validate_message(message)
      end

    end
  end
end