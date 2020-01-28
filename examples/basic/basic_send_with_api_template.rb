require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BasicSendWithApiTemplate
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BasicMessage.new

    message.subject = "Sending An Email Using a Template"
    message.api_template = 1

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

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

res = BasicSendWithApiTemplate.new.execute