require "../socketlabs/injectionapi/message/basic_message"
require "../socketlabs/injectionapi/message/email_address"
require "json"

class Test
  include SocketLabs::InjectionApi::Message

  def execute
    message = BasicMessage.new

    message.subject = "Sending A Test Message (Basic Send)"
    message.html_body = "<html><body>" \
                    "<h1>Sending A Test Message</h1>" \
                    "<p>This is the Html Body of my message.</p>" \
                    "</body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")
    message.add_to_email_address("recipient2@example.com", "Recipient #2")
    message.add_to_email_address(EmailAddress.new("recipient3@example.com"))
    message.add_to_email_address(EmailAddress.new("recipient4@example.com", "Recipient #4"))

    message.add_to_email_address(:email_address => "recipient66@example.com")
    message.add_to_email_address(:email_address => "recipient77@example.com", :friendly_name =>"Recipient #77")

    email_addresses = Array.new
    email_addresses.push("recipient5@example.com")
    email_addresses.push(EmailAddress.new("recipient6@example.com"))
    email_addresses.push(EmailAddress.new("recipient7@example.com", "Recipient #7"))


    email_addresses.push(:email_address => "recipient88@example.com")
    email_addresses.push(:email_address => "recipient99@example.com", :friendly_name =>"Recipient #99")

    message.add_to_email_address(email_addresses)


    message.add_to_email_address(OpenStruct.new(:email_address => "recipient111@example.com"))
    message.add_to_email_address(OpenStruct.new(:email_address => "recipient222@example.com", :friendly_name =>"Recipient #222"))


    puts message

    json = message.as_json
    puts JSON.pretty_generate(json)

  end
end


res = Test.new.execute