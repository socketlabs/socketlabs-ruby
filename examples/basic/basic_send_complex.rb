require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendComplex
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Complex Test Message (Basic Send))"
    message.html_body = "<html><body><h1>Sending A Complex Test Message</h1><p>This is the Html Body of my message.</p><h2>UTF16 Characters:</h2><p>例 (example)</p><h2>Embedded Image:</h2><p><img src=\"cid:bus\" /></p></body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."
    message.amp_body = "<!doctype html>" +
        "<html amp4email>" +
        "    <head>" +
        "    <meta charset=\"utf-8\">" +
        "     <script async src=\"https://cdn.ampproject.org/v0.js\"></script>" +
        "    <style amp4email-boilerplate>body{visibility:hidden}</style>" +
        "     <style amp-custom>" +
        "         h1 {" +
        "              margin: 1rem;" +
        "            }" +
        "      </style>" +
        "   </head>" +
        "        <body>" +
        "         <h1>This is the AMP Html Body of my message</h1>" +
        "        </body>" +
        "</html>"

    message.message_id = "ComplexExample"
    message.mailing_id = "BasicSend"
    message.charset = "UTF16"

    message.from_email_address = EmailAddress.new("from@example.com")
    message.reply_to_email_address = EmailAddress.new("replyto@example.com")

    # Adding To Recipients
    # --------
    # Add Email Addresses using an Array
    email_addresses = Array.new
    # String in array
    email_addresses.push("recipient1@example.com")
    # EmailAddress object in array
    email_addresses.push(EmailAddress.new("recipient2@example.com"))
    email_addresses.push(EmailAddress.new("recipient3@example.com", "Recipient #3"))
    # hash in array
    email_addresses.push({:email_address => "recipient4@example.com"})
    email_addresses.push({:email_address => "recipient5@example.com", :friendly_name =>"Recipient #5"})

    message.to_email_address = email_addresses

    # Add Email Addresses directly to the Array
    # String
    message.to_email_address.push("recipient11@example.com")
    # EmailAddress object
    message.to_email_address.push(EmailAddress.new("recipient12@example.com"))
    message.to_email_address.push(EmailAddress.new("recipient13@example.com", "Recipient #13"))
    # hash in array
    message.to_email_address.push({:email_address => "recipient14@example.com"})
    message.to_email_address.push({:email_address => "recipient15@example.com", :friendly_name =>"Recipient #15"})

    # Add Email Addresses using the add_to_email_address function
    # String
    message.add_to_email_address("recipient21@example.com")
    message.add_to_email_address("recipient22@example.com", "Recipient #22")
    # EmailAddress object
    message.add_to_email_address(EmailAddress.new("recipient23@example.com"))
    message.add_to_email_address(EmailAddress.new("recipient24@example.com", "Recipient #24"))
    # hash
    message.add_to_email_address({:email_address => "recipient25@example.com"})
    message.add_to_email_address({:email_address => "recipient26@example.com", :friendly_name =>"Recipient #26"})

    # adding Array
    # Add Email Addresses using an Array
    email_addresses = Array.new
    # String in array
    email_addresses.push("recipient31@example.com")
    # EmailAddress object in array
    email_addresses.push(EmailAddress.new("recipient32@example.com"))
    email_addresses.push(EmailAddress.new("recipient33@example.com", "Recipient #33"))
    # hash in array
    email_addresses.push({:email_address => "recipient34@example.com"})
    email_addresses.push({:email_address => "recipient35@example.com", :friendly_name =>"Recipient #35"})

    message.add_to_email_address(email_addresses)

    # Adding CC Recipients
    # --------
    # Add Email Addresses using an Array
    email_addresses = Array.new
    email_addresses.push("cc_recipient1@example.com")
    email_addresses.push(EmailAddress.new("cc_recipient2@example.com"))
    email_addresses.push({:email_address => "cc_recipient3@example.com", :friendly_name =>"CC Recipient #3"})

    message.cc_email_address = email_addresses

    # Add Email Addresses directly to the Array
    message.cc_email_address.push("cc_recipient4@example.com")
    message.cc_email_address.push(EmailAddress.new("cc_recipient5@example.com", "CC Recipient #5"))
    message.cc_email_address.push({:email_address => "cc_recipient6@example.com", :friendly_name =>"CC Recipient #6"})

    # Add Email Addresses using the add_to_email_address function
    message.add_cc_email_address("cc_recipient7@example.com", "CC Recipient #7")
    message.add_cc_email_address(EmailAddress.new("cc_recipient8@example.com"))
    message.add_cc_email_address({:email_address => "cc_recipient9@example.com", :friendly_name =>"CC Recipient #9"})

    # Add Email Addresses using an Array
    email_addresses = Array.new
    email_addresses.push("cc_recipient10@example.com")
    email_addresses.push(EmailAddress.new("cc_recipient11@example.com", "CC Recipient #11"))
    email_addresses.push({:email_address => "cc_recipient12@example.com", :friendly_name =>"CC Recipient #12"})

    message.add_cc_email_address(email_addresses)

    # Adding BCC Recipients
    # --------
    # Add Email Addresses using an Array
    email_addresses = Array.new
    email_addresses.push("bcc_recipient1@example.com")
    email_addresses.push(EmailAddress.new("bcc_recipient2@example.com"))
    email_addresses.push({:email_address => "bcc_recipient3@example.com", :friendly_name =>"BCC Recipient #3"})

    message.bcc_email_address = email_addresses

    # Add Email Addresses directly to the Array
    message.bcc_email_address.push("bcc_recipient4@example.com")
    message.bcc_email_address.push(EmailAddress.new("bcc_recipient5@example.com", "BCC Recipient #5"))
    message.bcc_email_address.push({:email_address => "bcc_recipient6@example.com", :friendly_name =>"BCC Recipient #6"})

    # Add Email Addresses using the add_to_email_address function
    message.add_bcc_email_address("bcc_recipient7@example.com", "BCC Recipient #7")
    message.add_bcc_email_address(EmailAddress.new("bcc_recipient8@example.com"))
    message.add_bcc_email_address({:email_address => "bcc_recipient9@example.com", :friendly_name =>"BCC Recipient #9"})

    # Add Email Addresses using an Array
    email_addresses = Array.new
    email_addresses.push("bcc_recipient10@example.com")
    email_addresses.push(EmailAddress.new("bcc_recipient11@example.com", "BCC Recipient #11"))
    email_addresses.push({:email_address => "bcc_recipient12@example.com", :friendly_name =>"BCC Recipient #12"})

    message.add_bcc_email_address(email_addresses)

    # Adding Custom Headers
    # --------
    # Add CustomHeader using a list
    headers = Array.new
    headers.push(CustomHeader.new("example-type", "basic-send-complex-example"))
    headers.push(CustomHeader.new("message-contains", "attachments, headers"))

    message.custom_headers = headers

    # Add CustomHeader directly to the list
    message.custom_headers.push(CustomHeader.new("message-has-attachments", "true"))

    # Add CustomHeader using the add_custom_header function
    message.add_custom_header("testMessageHeader", "I am a message header")
    message.add_custom_header(CustomHeader.new("testMessageHeader2", "I am another message header"))

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

    # Adding Attachments
    attachment1 = Attachment.new(
        name:"bus",
        file_path:"../img/bus.png",
        mime_type:"image/png"
    )
    message.attachments.push(attachment1)

    # Add Attachment using the add_attachment function
    attachment2 = Attachment.new(
        name:"bus2",
        file_path:"../img/bus.png",
        mime_type:"image/png"
    )
    attachment2.content_id = "bus"
    message.add_attachment(attachment2)

    # Add Attachment a filePath {string} to the array
    message.add_attachment(Attachment.new(file_path:"../html/SampleEmail.html"))

    # Add Attachment using bytes of the file
    file_path = "../img/bus.png"
    file = File.open(file_path, "rb")
    data = Base64.encode64(file.read)

    attachment4 = Attachment.new(
        name: "yellow-bus.png",
        mime_type: "image/png",
        content: data
    )

    # Add CustomHeaders to Attachment
    attachment4.custom_headers.push(CustomHeader.new("Color", "Yellow"))
    attachment4.add_custom_header("Place", "Beach")

    message.add_attachment(attachment4)

    message
  end

end
