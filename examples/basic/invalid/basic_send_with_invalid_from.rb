require_relative "../../../lib/socketlabs-ruby.rb"
require "json"

class BasicSendWithInvalidFrom
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Test Message"
    message.html_body = "<html>This is the Html Body of my message.</html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("!@#$!@#$!@#$@#!$")
    message.reply_to_email_address = EmailAddress.new("replyto@example.com")

    message.add_to_email_address("recipient@example.com")

    message

  end

end
