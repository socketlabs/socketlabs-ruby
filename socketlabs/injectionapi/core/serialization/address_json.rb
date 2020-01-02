module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents an individual email address for a message.
        # To be serialized into JSON string before sending to the Injection Api.
        class AddressJson

          # the email address
          attr_accessor :email_address
          #the friendly or display name
          attr_accessor :friendly_name

          # Initializes a new instance of the AddressJson class
          # @param [String] email_address
          # @param [String] friendly_name
          def initialize(
            email_address = nil, 
            friendly_name = nil
          )
            @email_address = email_address
            @friendly_name = friendly_name
          end

          # build json hash for AddressJson
          # @return [hash]
          def to_json
            if StringExtension.is_nil_or_white_space(@friendly_name)
              {
                  :emailAddress  => @email_address
              }
            else
              {
                  :emailAddress => @email_address,
                  :friendlyName => @friendly_name
              }
            end
          end

        end

      end
    end
  end
end