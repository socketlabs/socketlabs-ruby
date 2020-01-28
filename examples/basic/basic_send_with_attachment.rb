require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BasicSendWithAttachment
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending An Email With An Attachment"
    message.html_body = "<html><body>" +
                    "<h1>Sending An Email With An Attachment</h1>" +
                    "<p>This is the Html Body of my message.</p>" +
                    "</body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

    # Adding Attachments
    # --------
    # Add Attachment using the add_attachment function
    attachment = Attachment.new(
        name:"bus.png",
        file_path:"../img/bus.png",
        mime_type:"image/png"
    )
    message.add_attachment(attachment)

    message
  end

end
