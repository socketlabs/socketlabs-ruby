module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents an individual email address for a message.
        # To be serialized into JSON string before sending to the Injection Api.
        class InjectionResponseDto
          
          # the response ErrorCode of the Injection Api send request
          attr_accessor :error_code
          # the transaction receipt of the Injection Api send request
          attr_accessor :transaction_receipt

          # Initializes a new instance of the AddressJson class
          # @param [String] error_code
          # @param [String] transaction_receipt
          # @param [Array] message_results
          def initialize(            
            error_code = nil, 
            transaction_receipt = nil, 
            message_results = nil
          )

            @error_code = error_code
            @transaction_receipt = transaction_receipt
            @message_results = message_results

          end

          # Get the array of MessageResultDto objects that contain the status of each message sent.
          # @return [Array]
          def message_results
            @message_results
          end

          # Set the array of MessageResultDto objects that contain the status of each message sent.
          # @param [Array] value
          def message_results=(value)
            @message_results = Array.new

            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? MessageResultDto
                  @message_results.push(v1)
                end
              end

            end
          end

          # build json hash for InjectionResponseDto
          # @return [hash]
          def to_hash

            json = {
              :errorCode => @server_id,
              :transactionReceipt => @api_key
            }

            if @message_results.length > 0
              e = Array.new
              @message_results.each do |value|
                e.push(value.to_hash)
              end
              json[:messageResult] = e
            end
            
            json
          end

        end

      end
    end
  end
end