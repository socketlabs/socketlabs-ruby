module SocketLabs
  module InjectionApi
    # The response of an SocketLabsClient send request.
    class SendResponse

      # The result [SendResult] of the SocketLabsClient send request.
      attr_accessor :result
      # The unique key generated by the Injection API if an unexpected error occurs during the SocketLabsClient
      # send request. This unique key can be used by SocketLabs support to troubleshoot the issue.
      attr_accessor :transaction_receipt
      # A Array of AddressResult objects that contain the status of each address that failed.
      # If no messages failed this array is empty.
      attr_accessor :address_results

      def initialize (
          result = nil,
          transaction_receipt= nil,
          address_results= nil,
          response_message= nil
      )
        @result = result
        @transaction_receipt = transaction_receipt
        @address_results = []

        unless address_results.nil?
          @address_results = address_results
        end

      end

      # A message detailing why the SocketLabsClient send request failed.
      def response_message
        unless @result.nil?
          @result[:message]
        end
      end

      # Represents the SendResponse as a str.
      def to_s
        "#{@result}: #{response_message}"
      end

      # build json hash for SendResponse
      def to_json(*)
        json = {
            :result => @result.to_json,
            :transactionReceipt => @transaction_receipt,
            :responseMessage => response_message
        }
        if @address_results.length > 0
          e = Array.new
          @address_results.each do |value|
            e.push(value.to_json)
          end
          json[:messageResults] = e
        end
        json.to_json
      end

    end

  end
end