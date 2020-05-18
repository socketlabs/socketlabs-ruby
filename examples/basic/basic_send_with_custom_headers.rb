
require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithCustomHeaders
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending An Email With Custom Headers"
    message.html_body =  "<html><body>" +
                    "<h1>Sending An Email With Custom Headers</h1>" +
                    "<p>This is the Html Body of my message.</p>" +
                    "</body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

    # Adding Custom Headers
    # --------
    # Add CustomHeader using a list
    headers = Array.new
    headers.push(CustomHeader.new("example-type", "basic-send-with-custom-headers"))
    headers.push(CustomHeader.new("message-contains", "headers"))

    message.custom_headers = headers

    # Add CustomHeader directly to the list
    message.custom_headers.push(CustomHeader.new("message-has-attachments", "true"))

    # Add CustomHeader using the add_custom_header function
    message.add_custom_header("testMessageHeader", "I am a message header")
    message.add_custom_header(CustomHeader.new("testMessageHeader2", "I am another message header"))


    message
  end

end
