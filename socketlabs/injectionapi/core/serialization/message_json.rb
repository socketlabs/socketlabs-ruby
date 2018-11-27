require "../socketlabs/injectionapi/core/string_extension"

module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MessageJson
          include SocketLabs::InjectionApi::Core

          attr_accessor :subject,
                        :plain_text_body,
                        :html_body,
                        :api_template,
                        :mailing_id,
                        :message_id,
                        :charset,
                        :from_email,
                        :reply_to,
                        :attachments,
                        :custom_headers,
                        :to_email_address,
                        :cc_email_address,
                        :bcc_email_address,
                        :merge_data

          def initialize
            @subject = nil
            @plain_text_body = nil
            @html_body = nil
            @api_template = nil
            @mailing_id = nil
            @message_id = nil
            @charset = nil
            @from_email = nil
            @reply_to = nil
            @attachments = Array.new
            @custom_headers = Array.new
            @to_email_address = Array.new
            @cc_email_address = Array.new
            @bcc_email_address = Array.new
            @merge_data = nil
          end

        end

        def to_json

          json = {
              from: @from_email_address.to_json
          }

          if StringExtension.is_nil_or_white_space(@subject)
              json[:subject] = @subject
          end

          if StringExtension.is_nil_or_white_space(@html_body)
              json[:htmlBody] = @html_body
          end

          if StringExtension.is_nil_or_white_space(@plain_text_body)
              json[:textBody] = @plain_text_body
          end

          if StringExtension.is_nil_or_white_space(@api_template)
              json[:apiTemplate] = @api_template
          end

          if StringExtension.is_nil_or_white_space(@mailing_id)
              json[:mailingId] = @mailing_id
          end

          if StringExtension.is_nil_or_white_space(@message_id)
              json[:messageId] = @message_id
          end

          if @reply_to != nil
              json[:replyTo] = @_reply_to.to_json
          end

          if StringExtension.is_nil_or_white_space(@charset)
              json[:charSet] = @charset
          end

          if len(@to_email_address) > 0:
              e = []
          for i in @to_email_address:
            e.append(i.to_json())
            json[:to] = e

            if len(@cc_email_address) > 0:
                e = []
            for i in @cc_email_address:
              e.append(i.to_json())
              json[:cc] = e

              if len(@bcc_email_address) > 0:
                  e = []
              for i in @bcc_email_address:
                e.append(i.to_json())
                json[:bcc] = e

                if len(@custom_headers) > 0:
                    e = []
                for i in @custom_headers:
                  e.append(i.to_json())
                  json[:customHeaders] = e

                  if len(@attachments) > 0:
                      e = []
                  for i in @attachments:
                    e.append(i.to_json())
                    json[:attachments] = e

                    if @merge_data:
                        json[:mergeData] = @merge_data.to_json()

                      
                    end
      end
    end
  end
end