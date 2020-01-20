require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BasicSend
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Test Message (Basic Send)"
    message.html_body = "<html><body><h1>Sending A Test Message</h1><p>This is the Html Body of my message.</p></body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")

    message.add_to_email_address("recipient1@example.com")
    message.add_to_email_address("recipient2@example.com", "Recipient #2")
    message.add_to_email_address(EmailAddress.new("recipient3@example.com"))
    message.add_to_email_address(EmailAddress.new("recipient4@example.com", "Recipient #4"))

    message.add_to_email_address("sl@gekodesign.net")

    message
  end

  public
  def execute

    message = get_message
    puts message

    server_id = ENV['SOCKETLABS_SERVER_ID']
    api_key = ENV['SOCKETLABS_INJECTION_API_KEY']

    client = SocketLabsClient.new(server_id, api_key)
    response = client.send(message)

    puts response.to_json

  end

end

res = BasicSend.new.execute