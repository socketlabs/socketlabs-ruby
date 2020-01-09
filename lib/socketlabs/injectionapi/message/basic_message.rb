require_relative 'message_base.rb'
require_relative 'email_address.rb'
require_relative 'helpers/to_email_address.rb'

module SocketLabs
  module InjectionApi
    module Message
      class BasicMessage


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


        public

        # the message Subject.
        attr_accessor :subject
        # the plain text portion of the message body.
        attr_accessor :plain_text_body
        # the HTML portion of the message body.
        attr_accessor :html_body
        # the Api Template for the message.
        attr_accessor :api_template
        # the custom MailingId for the message.
        # See https://www.injectionapi.com/blog/best-practices-for-using-custom-mailingids-and-messageids/
        # for more information.
        attr_accessor :mailing_id
        # the custom MessageId for the message.
        # See https://www.injectionapi.com/blog/best-practices-for-using-custom-mailingids-and-messageids/
        # for more information.
        attr_accessor :message_id
        # the optional character set. Default is UTF-8
        attr_accessor :charset

        def initialize

          @subject = subject
          @plain_text_body = plain_text_body
          @html_body = html_body
          @api_template = api_template
          @mailing_id = mailing_id
          @message_id = message_id
          @charset = charset
          @from_email_address = nil
          @reply_to_email_address = nil
          @attachments = nil
          @custom_headers = nil

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

        # Get the From email address.
        def from_email_address
          @from_email_address
        end
        # Set the From email address.
        def from_email_address=(value)
          unless value.nil?
            if value.kind_of? EmailAddress
              @from_email_address = value
            elsif value.kind_of? String
              @from_email_address = EmailAddress.new(value)
            else
              raise StandardError("Invalid type for reply_to_email_address, type of 'EmailAddress' or 'String' was expected")
            end
          end
        end

        # Get the optional reply to  email address for the message.
        def reply_to_email_address
          @reply_to_email_address
        end
        # Set the optional reply to address for the message.
        def reply_to_email_address=(value)
          unless value.nil?
            if value.kind_of?(EmailAddress)
              @reply_to_email_address = value
            elsif value.kind_of? String
              @from_email_address = EmailAddress.new(value)
            else
              raise StandardError("Invalid type for reply_to_email_address, type of 'EmailAddress' or 'String' was expected")
            end
          end
        end

        # Get the list of attachments.
        def attachments
          @attachments
        end
        # Set the list of attachments.
        def attachments=(value)
          @attachments = Array.new
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? Attachment
                @attachments.push(v1)
              else
                raise StandardError("Invalid type for attachments, type of 'Attachment' was expected")
              end
            end
          end
        end
        # Add an attachment to the attachments list.
        def add_attachment(value)
          @attachments.push(value)
        end

        # Get the list of custom message headers added to the message.
        def custom_headers
          @custom_headers
        end
        # Set the list of custom message headers added to the message.
        def custom_headers=(value)
          @custom_headers = Array.new
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? CustomHeader
                @custom_headers.push(v1)
              else
                raise StandardError("Invalid type for custom_headers, type of 'CustomHeader' was expected")
              end
            end
          end
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


      end
    end
  end
end