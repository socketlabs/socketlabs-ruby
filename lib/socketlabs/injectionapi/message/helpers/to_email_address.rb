require_relative '../email_address.rb'

module SocketLabs
  module InjectionApi
    module Message
      module Helpers

        class ToEmailAddress


          private
          def convert_email_address(array_instance, email_address, friendly_name = nil)

            if email_address.is_a? Array
              convert_email_address_array(array_instance, email_address)
            else
              convert_email_address_object(array_instance, email_address, friendly_name)
            end
          end

          def convert_email_address_object(array_instance, email_address, friendly_name = nil)
            unless email_address.nil?

              if email_address.is_a? EmailAddress
                array_instance.push(email_address)

              elsif email_address.is_a? String
                array_instance.push(EmailAddress.new(email_address, friendly_name))

              elsif email_address.instance_of? Hash or email_address.is_a? OpenStruct
                array_instance.push(EmailAddress.new(email_address[:email_address], email_address[:friendly_name]))

              end

            end

          end

          def convert_email_address_array(array_instance, value)

            if value.is_a? Array
              value.each do |x|
                array_instance << convert_email_address_object(array_instance, x)
              end
            end

          end



        end

      end
    end
  end
end
