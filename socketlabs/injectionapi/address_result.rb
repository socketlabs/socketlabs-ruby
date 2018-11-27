module SocketLabs
  module InjectionApi
    #The result of a single recipient in the Injection request.
    class AddressResult

      attr_accessor :email_address, :accepted, :error_code

      def initialize (email_address= nil, accepted= nil, error_code= nil)
        @email_address = email_address
        @accepted = accepted
        @error_code = error_code
      end

      def to_s
        "#{self.error_code}: #{self.email_address}"
      end

      def to_json(*)
        {
            'errorCode' => self.error_code,
            'accepted' => self.accepted,
            'emailAddress' => self.email_address
        }.delete_if { |_, value| value.to_s.strip == '' || value == [] || value == {}}
      end

    end

  end
end