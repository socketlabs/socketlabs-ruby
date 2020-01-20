module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents a injection request for sending to the Injection Api.
        # To be serialized into JSON string before sending to the Injection Api.
        class InjectionRequest

          # the SocketLabs Injection API key for the Injection Request.
          attr_accessor :api_key
          # the server id for the injection Request.
          attr_accessor :server_id
          # the list of messages (MessageJson) to send. This library is limited to one
          attr_accessor :messages

          # Initializes a new instance of the InjectionRequest class
          # @param [String] api_key
          # @param [String] server_id
          # @param [String] messages
          def initialize(
            server_id = nil,
            api_key = nil,
            messages = nil
          )
            @api_key = api_key
            @server_id = server_id
            @messages = messages
          end

          # build json hash for InjectionRequest
          # @return [hash]
          def to_hash

            json = {
              :serverId => @server_id,
              :apiKey => @api_key
            }

            if @messages.length > 0
              e = Array.new
              @messages.each do |value|
                e.push(value.to_hash)
              end
              json[:messages] = e
            end
            
            json
          end

        end

      end
    end
  end
end