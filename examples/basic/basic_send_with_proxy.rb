require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BasicSendWithProxy
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Complex Test Message (Basic Send))"
    message.html_body = "<html><body><h1>Sending An Email Through A Proxy</h1><p>This is the Html Body of my message.</p></body></html>"
    message.plain_text_body = "This is the Plain Text Body of my message."

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient@example.com")

    message
  end

  public
  def execute

    message = get_message
    puts message

    server_id = ENV['SOCKETLABS_SERVER_ID']
    api_key = ENV['SOCKETLABS_INJECTION_API_KEY']

    # create the proxy hash. accepted values: :host, :port, :user, :pass
    proxy = { :host =>"127.0.0.1", :port => 8888 }

    client = SocketLabsClient.new(server_id, api_key, proxy)
    response = client.send(message)

    puts response.to_json

  end

end

res = BasicSendWithProxy.new.execute