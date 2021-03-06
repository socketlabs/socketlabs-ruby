require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithRetry
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Complex Test Message (Basic Send))"
    message.html_body = "<html><body><h1>Sending An Email with retry</h1><p>This is the Html Body of my message.</p></body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient@example.com")

    message
  end

end
