
require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithMetadata
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

    # Adding Metadata
    # --------
    # Add Metadata using a list
    metadata = Array.new
    metadata.push(Metadata.new("x-mycustommetadata", "I am custom metadata"))
    metadata.push(Metadata.new("x-internalid", "123"))

    message.metadata = metadata

    # Add Metadata directly to the list
    message.metadata.push(Metadata.new("x-mycustommetadata", "I am custom metadata"))

    # Add Metadata using the add_metadata function
    message.add_metadata("x-mycustommetadata2", "Custom metadata")
    message.add_metadata(Metadata.new("x-externalid", "456"))


    message
  end

end
