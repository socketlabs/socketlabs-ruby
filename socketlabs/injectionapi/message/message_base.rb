module SocketLabs
  module Message
    module InjectionApi
      class MessageBase

        attr_accessor :subject,
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

      end
    end
  end
end