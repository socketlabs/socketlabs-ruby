module SocketLabs
  module InjectionApi
    module Message
      module Helpers

        class ToEmailAddress

          def convert(value, friendly_name = nil)
            if value == nil
              nil

            elsif value.is_a? EmailAddress
              value

            elsif value.is_a? String
              EmailAddress.new(value, friendly_name)

            elsif value.is_a? Hash or value.is_a? OpenStruct
              EmailAddress.new(value[:email_address], value[:friendly_name])

            else
              raise "Invalid email address, the email address was not submitted in an expected format!"

            end

          end

          def convert_array(value)

            email_address_array = Array.new

            if value.is_a? Array
              value.each do |x|
                email_address_array << self.convert(x)
              end

              email_address_array

            else
              raise "Invalid array, the array if email addresses was not submitted in an expected format!"

            end

          end

        end

      end
    end
  end
end
