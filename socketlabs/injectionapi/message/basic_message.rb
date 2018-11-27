require "../socketlabs/injectionapi/message/helpers/to_email_address"

module SocketLabs
  module InjectionApi
    module Message
      class BasicMessage
        include SocketLabs::InjectionApi::Message::Helpers

        attr_accessor :to_email_address,
                      :cc_email_address,
                      :bcc_email_address,:subject,
                      :plain_text_body,
                      :html_body,
                      :api_template,
                      :mailing_id,
                      :message_id,
                      :charset,
                      :from_email_address,
                      :reply_to_email_address,
                      :attachments,
                      :custom_headers

        def initialize
          @subject = nil
          @plain_text_body = nil
          @html_body = nil
          @api_template = nil
          @mailing_id = nil
          @message_id = nil
          @charset = nil
          @from_email_address = nil
          @reply_to_email_address = nil
          @attachments = Array.new
          @custom_headers = Array.new
          @to_email_address = Array.new
          @cc_email_address = Array.new
          @bcc_email_address = Array.new
        end

        def add_to_email_address(email_address, friendly_name = nil)
          if email_address.is_a? Array
            @to_email_address.push(*ToEmailAddress.new.convert_array(email_address))

          else
            @to_email_address << ToEmailAddress.new.convert(email_address, friendly_name)
          end
        end

        def add_cc_email_address(email_address, friendly_name = nil)
          if email_address.is_a? Array
            @cc_email_address.push(*ToEmailAddress.new.convert_array(email_address))
          else
            @cc_email_address << ToEmailAddress.new.convert(email_address, friendly_name)
          end
        end

        def add_bcc_email_address(email_address, friendly_name = nil)
          if email_address.is_a? Array
            @bcc_email_address.push(*ToEmailAddress.new.convert_array(email_address))
          else
            @bcc_email_address << ToEmailAddress.new.convert(email_address, friendly_name)
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