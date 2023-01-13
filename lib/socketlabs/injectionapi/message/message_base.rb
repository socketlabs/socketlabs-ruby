
module SocketLabs
  module InjectionApi
    module Message
      class MessageBase

        public
        # the message Subject.
        attr_accessor :subject
        # the plain text portion of the message body.
        # (Optional) Either TextBody or HtmlBody must be used with the AmpBody or use a ApiTemplate
        attr_accessor :plain_text_body
        # the HTML portion of the message body.
        # (Optional) Either TextBody or HtmlBody must be used with the AmpBody or use a ApiTemplate
        attr_accessor :html_body
        # the AMP portion of the message body.
        # (Optional) Either TextBody or HtmlBody must be used with the AmpBody or use a ApiTemplate
        attr_accessor :amp_body
        # the Api Template for the message.
        # (Optional) Either TextBody or HtmlBody must be used with the AmpBody or use a ApiTemplate
        attr_accessor :api_template
        # the custom MailingId for the message.
        # See https://www.socketlabs.com/blog/best-practices-for-using-custom-mailingids-and-messageids/
        # for more information.
        attr_accessor :mailing_id
        # the custom MessageId for the message.
        # See https://www.socketlabs.com/blog/best-practices-for-using-custom-mailingids-and-messageids/
        # for more information.
        attr_accessor :message_id
        # the optional character set. Default is UTF-8
        attr_accessor :charset

        def initialize(arguments = nil)

          unless arguments.nil? || arguments.empty?

            unless arguments[:subject].nil? || arguments[:subject].empty?
              @subject = arguments[:subject]
            end

            unless arguments[:plain_text_body].nil? || arguments[:plain_text_body].empty?
              @plain_text_body = arguments[:plain_text_body]
            end

            unless arguments[:html_body].nil? || arguments[:html_body].empty?
              @html_body = arguments[:html_body]
            end

            unless arguments[:amp_body].nil? || arguments[:amp_body].empty?
              @amp_body = arguments[:amp_body]
            end

            unless arguments[:api_template].nil? || arguments[:api_template].empty?
              @api_template = arguments[:api_template]
            end

            unless arguments[:mailing_id].nil? || arguments[:mailing_id].empty?
              @mailing_id = arguments[:mailing_id]
            end

            unless arguments[:message_id].nil? || arguments[:message_id].empty?
              @message_id = arguments[:message_id]
            end

            unless arguments[:charset].nil? || arguments[:charset].empty?
              @charset = arguments[:charset]
            end

            unless arguments[:charset].nil? || arguments[:charset].empty?
              @charset = arguments[:charset]
            end

          end

          @from_email_address = nil
          @reply_to_email_address = nil

          @attachments = Array.new
          @custom_headers = Array.new

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
        # Add a CustomHeader to the message.
        # @param [String/CustomHeader] name
        # @param [String] value
        def add_custom_header(header, value = nil)

          if header.kind_of? CustomHeader
            @custom_headers.push(header)

          elsif header.kind_of? String
            @custom_headers.push(CustomHeader.new(header, value))

          end

        end



      end
    end
  end
end

