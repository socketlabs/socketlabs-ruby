require_relative 'message_base.rb'
require_relative 'email_address.rb'

module SocketLabs
  module InjectionApi
    module Message
      class BasicMessage < MessageBase

        def initialize(arguments = nil)
          super

          @to_email_address = Array.new
          @cc_email_address = Array.new
          @bcc_email_address = Array.new

        end

        # Get the To EmailAddress list
        def to_email_address
          @to_email_address
        end
        # Set the To EmailAddress list
        def to_email_address=(value)
          @to_email_address = Array.new
          convert_email_address(@to_email_address, value)
        end
        # Add an EmailAddress to the To recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_to_email_address(email_address, friendly_name = nil)
          convert_email_address(@to_email_address, email_address, friendly_name)
        end

        # Get the CC EmailAddress list
        def cc_email_address
          @cc_email_address
        end
        # Set the CC EmailAddress list
        def cc_email_address=(value)
          @cc_email_address = Array.new
          convert_email_address(@cc_email_address, value)
        end
        # Add an EmailAddress to the CC recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_cc_email_address(email_address, friendly_name = nil)
          convert_email_address(@cc_email_address, email_address, friendly_name)
        end

        # Get the CC EmailAddress list
        def bcc_email_address
          @bcc_email_address
        end
        # Set the CC EmailAddress list
        def bcc_email_address=(value)
          @bcc_email_address = Array.new
          convert_email_address(@bcc_email_address, value)
        end
        # Add an EmailAddress to the CC recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_bcc_email_address(email_address, friendly_name = nil)
          convert_email_address(@bcc_email_address, email_address, friendly_name)
        end


        def to_s
          c = @to_email_address.any? ? @to_email_address.count : 0
          c = c + (@cc_email_address.any? ? @cc_email_address.count : 0)
          c = c + (@bcc_email_address.any? ? @bcc_email_address.count : 0)

          "Recipients: #{c}, Subject: '#{@subject}'"

        end

        def to_json
          {
              subject: @subject,
              textBody: @plain_text_body,
              htmlBody: @html_body,
              apiTemplate: @api_template,
              mailingId: @mailing_id,
              messageId: @message_id,
              charSet: @charset,
              from: @from_email_address,
              replyTo: @reply_to_email_address,
              attachments: @attachments,
              customHeaders: @custom_headers,
              to: @to_email_address,
              cc: @cc_email_address,
              bcc: @bcc_email_address
          }
        end

        private
        def convert_email_address(array_instance, email_address, friendly_name = nil)

          if email_address.kind_of? Array
            convert_email_address_array(array_instance, email_address)
          else
            convert_email_address_object(array_instance, email_address, friendly_name)
          end
        end

        def convert_email_address_object(array_instance, email_address, friendly_name = nil)
          unless email_address.nil?

            if email_address.kind_of? EmailAddress
              array_instance.push(email_address)

            elsif email_address.kind_of? String
              array_instance.push(EmailAddress.new(email_address, friendly_name))

            elsif email_address.kind_of? Hash or email_address.kind_of? OpenStruct
              array_instance.push(EmailAddress.new(email_address[:email_address], email_address[:friendly_name]))

            end

          end

        end

        def convert_email_address_array(array_instance, value)

          if value.kind_of? Array
            value.each do |x|
              convert_email_address_object(array_instance, x)
            end
          end

        end

      end
    end
  end
end