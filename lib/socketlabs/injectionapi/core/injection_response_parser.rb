
require_relative 'serialization/injection_response_dto.rb'
require_relative 'serialization/message_result_dto.rb'

module SocketLabs
  module InjectionApi
    module Core

      class InjectionResponseParser
        include SocketLabs::InjectionApi
        include SocketLabs::InjectionApi::Message
        include SocketLabs::InjectionApi::Core::Serialization

        # Parse the response from the Injection Api into SendResponse
        # @param [HttpResponse] response: the response form the Injection Api
        # @return [SendResponse]
        def parse(response)

          injection_response = get_injection_response_dto(response)
          result_enum = determine_send_result(injection_response, response)
          new_response = SendResponse.new(result_enum)
          new_response.transaction_receipt = injection_response.transaction_receipt

          if result_enum == SendResult.enum[:Warning]
            unless injection_response.message_results.nil? || injection_response.message_results.length == 0
              error_code = injection_response.message_results[0].error_code
              result_enum = SendResult.enum.select {|enum| enum[:value] = error_code }
              new_response.result = result_enum
            end
          end

          unless injection_response.message_results.nil? || injection_response.message_results.length == 0
            new_response.address_results = injection_response.message_results[0].address_results
          end

          new_response

        end

        # Get the InjectionResponseDto from the HttpResponse object
        # @param [HttpResponse] response: the Http response
        # @return [InjectionResponseDto] the converted injection response dto
        def get_injection_response_dto(response)

          hash_body = response.to_hash

          resp_dto = InjectionResponseDto.new

          if hash_body.key?(:ErrorCode)
            resp_dto.error_code = hash_body[:ErrorCode]
          end

          if hash_body.key?(:TransactionReceipt)
            resp_dto.transaction_receipt = hash_body[:TransactionReceipt]
          end

          if hash_body.key?(:MessageResults)

            resp_dto.message_results = Array.new
            message_results = hash_body[:MessageResults]

            unless message_results.nil?
              message_results.each do |item|
                message_dto = MessageResultDto.new

                if item.key?(:Index)
                  message_dto.index = item[:Index]
                end

                if item.key?(:AddressResults)
                  message_dto.address_results = item[:Index]
                end

                if item.key?(:ErrorCode)
                  message_dto.error_code = item[:ErrorCode]
                end

                resp_dto.message_results.push(message_dto)

              end
            end

            resp_dto

          end


        end

        # Enumerated SendResult of the payload response from the Injection Api
        # @param [InjectionResponseDto] response_dto: the response dto
        # @param [HttpResponse] response: the Http response
        # @return [SendResult]  the parsed result of the injection request
        def determine_send_result(response_dto, response)

          # HttpStatusCode.OK
          if response.status_code == 200
            error_code = response_dto.error_code
            result_enum = SendResult.enum.select {|enum| enum[:value] = error_code }
            unless result_enum.nil? || result_enum.empty?
              result_enum = SendResult.enum[:UnknownError]
            end

          # HttpStatusCode.Unauthorized
          elsif response.status_code == 500
            result_enum = SendResult.enum[:InternalError]

          # HttpStatusCode.Unauthorized
          elsif response.status_code == 408
            result_enum = SendResult.enum[:Timeout]

          # HttpStatusCode.Unauthorized
          else
            result_enum = SendResult.enum[:InvalidAuthentication]

          end

          result_enum

        end

      end

    end
  end
end
