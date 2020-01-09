require "message_base.rb"
require "email_address.rb"

module SocketLabs
  module InjectionApi
    module Message
      class BasicMessage < MessageBase
        include SocketLabs::InjectionApi
        include SocketLabs::InjectionApi::Message

        def initialize
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
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? EmailAddress
                @to_email_address.push(v1)
              else
                raise StandardError("Invalid type for to_email_address, type of 'EmailAddress' was expected")
              end
            end
          end
        end
        # Add an EmailAddress to the To recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_to_email_address(email_address, friendly_name = nil)
          if email_address.instance_of? EmailAddress
            @to_email_address.push(email_address)
          elsif email_address.instance_of? String
            @to_email_address.push(EmailAddress.new(email_address, friendly_name))
          end
        end

        # Get the CC EmailAddress list
        def cc_email_address
          @cc_email_address
        end
        # Set the CC EmailAddress list
        def cc_email_address=(value)
          @cc_email_address = Array.new
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? EmailAddress
                @cc_email_address.push(v1)
              else
                raise StandardError("Invalid type for cc_email_address, type of 'EmailAddress' was expected")
              end
            end
          end
        end
        # Add an EmailAddress to the CC recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_cc_email_address(email_address, friendly_name = nil)
          if email_address.instance_of? EmailAddress
            @cc_email_address.push(email_address)
          elsif email_address.instance_of? String
            @cc_email_address.push(EmailAddress.new(email_address, friendly_name))
          end
        end

        # Get the CC EmailAddress list
        def bcc_email_address
          @bcc_email_address
        end
        # Set the CC EmailAddress list
        def bcc_email_address=(value)
          @bcc_email_address = Array.new
          unless value.nil? || value.empty?
            value.each do |v1|
              if v1.instance_of? EmailAddress
                @bcc_email_address.push(v1)
              else
                raise StandardError("Invalid type for bcc_email_address, type of 'EmailAddress' was expected")
              end
            end
          end
        end
        # Add an EmailAddress to the CC recipient list.
        # @param [String] email_address
        # @param [String] friendly_name
        def add_bcc_email_address(email_address, friendly_name = nil)
          if email_address.instance_of? EmailAddress
            @bcc_email_address.push(email_address)
          elsif email_address.instance_of? String
            @bcc_email_address.push(EmailAddress.new(email_address, friendly_name))
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