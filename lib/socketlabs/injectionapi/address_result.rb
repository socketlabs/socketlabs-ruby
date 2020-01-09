module SocketLabs
  module InjectionApi
    #The result of a single recipient in the Injection request.
    class AddressResult

      # The recipient's email address.
      attr_accessor :email_address
      # Whether the recipient was accepted for delivery.
      attr_accessor :accepted
      # An error code detailing why the recipient was not accepted.
      attr_accessor :error_code

      def initialize (
          email_address= nil,
          accepted= nil,
          error_code= nil
      )
        @email_address = email_address
        @accepted = accepted
        @error_code = error_code
      end

      # Represents the AddressResult as a str.  Useful for debugging.
      # @return [String]
      def to_s
        "#{@error_code}: #{@email_address}"
      end

      # build json hash for AddressResult
      def to_json(*)
        {
            :errorCode => @error_code,
            :accepted => @accepted,
            :emailAddress => @email_address
        }.delete_if { |_, value| value.to_s.strip == '' || value == [] || value == {}}
      end

    end

  end
end