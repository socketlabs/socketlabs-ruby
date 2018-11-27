require "../socketlabs/injectionapi/core/string_extension"

module SocketLabs
  module InjectionApi
    module Message
      class EmailAddress
        include SocketLabs::InjectionApi::Core

        attr_accessor :email_address,
                      :friendly_name

        def initialize(email_address, friendly_name = nil)
          @email_address = email_address
          @friendly_name = friendly_name
        end

        def is_valid
          StringExtension.is_valid_email_address(@email_address)
        end

        def to_s
          if StringExtension.is_nil_or_white_space(@friendly_name)
            @email_address
          else
            "#{@friendly_name} <#{@email_address}>"
          end

        end


      end
    end
  end
end