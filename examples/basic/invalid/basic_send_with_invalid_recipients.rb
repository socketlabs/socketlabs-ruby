require_relative "../../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithInvalidRecipients
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Test Message"
    message.html_body = "<html>This is the Html Body of my message.</html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.reply_to_email_address = EmailAddress.new("replyto@example.com")

    message.add_to_email_address("!@#$!@#$!@#$@#!$")
    message.add_to_email_address("failure.com")
    message.add_to_email_address(EmailAddress.new("ImMissingSomething"))
    message.add_to_email_address("Fail@@!.Me");
    message.add_to_email_address(EmailAddress.new("this@works"))
    message.add_to_email_address("recipient@example.com")


    message
  end

end
