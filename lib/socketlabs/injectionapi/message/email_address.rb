require_relative '../core/string_extension.rb'

module SocketLabs
  module InjectionApi
    module Message

        # Represents an individual email address for a message.
        # Example:
        #   email_address = EmailAddress.new("recipient@example.com", "Recipient 1")

        class EmailAddress
          include SocketLabs::InjectionApi
          include SocketLabs::InjectionApi::Core

        # the email address
        attr_accessor :email_address
        # the friendly or display name
        attr_accessor :friendly_name

        # Initializes a new instance of the EmailAddress class
        # @param [String] email_address
        # @param [String] friendly_name
        def initialize(
            email_address,
            friendly_name = nil
        )
          @email_address = email_address
          @friendly_name = friendly_name
        end

        # Determines if the EmailAddress is valid. Does simple syntax validation on the email address.
        # @return [Boolean]
        def is_valid
          StringExtension.new.is_valid_email_address(@email_address)
        end

        # Represents the EmailAddress as a string
        # @return [String]
        def to_s
          if @friendly_name.nil? || @friendly_name.empty?
            @email_address
          else
            "#{@friendly_name} <#{@email_address}>"
          end

        end


      end
    end
  end
end