require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BulkSend
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Complex Test Message (Bulk Send)"
    message.html_body = "<html><body>" +
                    "<h1>Sending A Test Message</h1>" +
                    "<p>This is the Html Body of my message.</p>" +
                    "</body></html>"

    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")

    message.add_to_recipient("recipient1@example.com")
    message.add_to_recipient("recipient2@example.com", "Recipient #2")
    message.add_to_recipient(BulkRecipient.new("recipient3@example.com"))
    message.add_to_recipient(BulkRecipient.new("recipient4@example.com", {:friendly_name => "Recipient #4"}))

    message

  end

end
