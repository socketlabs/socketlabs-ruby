require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithApiTemplate
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending An Email Using a Template"
    message.api_template = 1

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

    message
  end


end
