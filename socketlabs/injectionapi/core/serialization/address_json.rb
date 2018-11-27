module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class AddressJson

          attr_accessor :email_address,
                        :friendly_name

          def initialize(email_address = nil, friendly_name = nil)
            @email_address = email_address
            @friendly_name = friendly_name
          end

          def to_json
            if StringExtension.is_nil_or_white_space(@friendly_name)
              {
                  emailAddress: @email_address
              }
            else
              {
                  emailAddress: @email_address,
                  friendlyName: @friendly_name
              }
            end
          end

        end

      end
    end
  end
end