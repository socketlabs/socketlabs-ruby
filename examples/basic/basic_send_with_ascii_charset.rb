require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithAsciiCharset
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A ASCII Charset Email"
    message.html_body =  "<html><body>" +
                    "<h1>Sending A ASCII Charset Email</h1>" +
                    "<p>This is the html Body of my message.</p>" +
                    "<h2>UTF-8 Characters:</h2><p>✔ - Check</p>" +
                    "</body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    # Set the CharSet
    message.charset = "ASCII"

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

    message
  end

end
