require_relative 'message_base.rb'
require_relative 'bulk_recipient.rb'

module SocketLabs
  module InjectionApi
    module Message
      class BulkMessage < MessageBase

        def initialize(arguments = nil)
          super
          @to_recipient = Array.new
          @global_merge_data = Array.new
        end

        attr_accessor :global_merge_data

        # Get the To BulkRecipient list
        def to_recipient
          @to_recipient
        end
        # Set the To BulkRecipient list
        def to_recipient=(value)
          @to_recipient = Array.new
          convert_bulk_recipient(@to_email_address, value)
        end

        # Add an BulkRecipient to the To recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        # @param [Array] merge_data
        def add_to_recipient(email_address, friendly_name = nil, merge_data = nil)
          convert_bulk_recipient(@to_recipient, email_address, friendly_name, merge_data)
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
            amp_Body: @amp_body,
            apiTemplate: @api_template,
            mailingId: @mailing_id,
            messageId: @message_id,
            charSet: @charset,
            from: @from_email_address,
            replyTo: @reply_to_email_address,
            attachments: @attachments,
            customHeaders: @custom_headers,
            metadata: @metadata,
            to: @to_recipient,
            global_merge_data: @global_merge_data
          }
        end

        private
        def convert_bulk_recipient(array_instance, recipient, friendly_name = nil, merge_data = nil)

          if recipient.kind_of? Array
            convert_bulk_recipient_array(array_instance, recipient)
          else
            convert_bulk_recipient_object(array_instance, recipient, friendly_name, merge_data)
          end
        end

        def convert_bulk_recipient_object(array_instance, recipient, friendly_name = nil, merge_data = nil)
          unless recipient.nil?

            if recipient.kind_of? BulkRecipient
              array_instance.push(recipient)

            elsif recipient.kind_of? String
              array_instance.push(BulkRecipient.new(recipient, { :friendly_name => friendly_name, :merge_data => merge_data }))

            elsif recipient.kind_of? Hash or recipient.kind_of? OpenStruct
              array_instance.push(BulkRecipient.new(email_address[:email_address], { :friendly_name => email_address[:friendly_name], :merge_data => email_address[:merge_data] }, ))

            end

          end

        end

        def convert_bulk_recipient_array(array_instance, value)

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