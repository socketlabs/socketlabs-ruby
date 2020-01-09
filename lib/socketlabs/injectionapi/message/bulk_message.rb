module SocketLabs
  module InjectionApi
    module Message
      class BulkMessage < MessageBase

        attr_accessor :global_merge_data

        def initialize
          @to_recipient = Array.new
          @global_merge_data = Array.new
        end

        # Get the To EmailAddress list
        def to_recipient
          @to_recipient
        end
        # Set the To EmailAddress list
        def to_recipient=(value)
          @to_recipient = Array.new
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? EmailAddress
                @to_recipient.push(v1)
              else
                raise StandardError("Invalid type for to_email_address, type of 'EmailAddress' was expected")
              end
            end
          end
        end
        # Add an EmailAddress to the To recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_to_recipient(email_address, friendly_name = nil)
          if email_address.instance_of? EmailAddress
            @to_recipient.push(email_address)
          elsif email_address.instance_of? String
            @to_recipient.push(EmailAddress.new(email_address, friendly_name))
          end
        end

        def add_global_merge_data(key, value)
          @global_merge_data.push(MergeData.new(key, value))
        end

        def to_s
          c = @to_recipient.any? ? @to_recipient.count : 0
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
            to: @to_recipient,
            global_merge_data: @global_merge_data
          }
        end

      end
    end
  end
end