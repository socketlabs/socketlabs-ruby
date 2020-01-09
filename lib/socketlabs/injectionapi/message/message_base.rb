module SocketLabs
  module Message
    module InjectionApi
      class MessageBase

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

        # Get the From email address.
        def from_email_address
          @from_email_address
        end
        # Set the From email address.
        def from_email_address=(value)
          unless value.nil?
            if value.kind_of?(EmailAddress)
              @from_email_address = value
            else
              raise StandardError("Invalid type for from_email_address, type of 'EmailAddress' was expected")
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
            else
              raise StandardError("Invalid type for reply_to_email_address, type of 'EmailAddress' was expected")
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

      end
    end
  end
end