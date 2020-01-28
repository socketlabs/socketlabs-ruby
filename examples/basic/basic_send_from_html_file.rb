require_relative "../../lib/socketlabs-ruby.rb"

require "json"

class BasicSendFromHtmlFile
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending An Email With Body From Html File"

    # Add Attachment using bytes of the file
    data = ""
    file_path = "../html/SampleEmail.html"
    File.open(file_path, "r:UTF-8") do |f|
      data = f.read
    end

    message.html_body = data

    message.from_email_address = EmailAddress.new("from@example.com")
    message.add_to_email_address("recipient1@example.com")

    message
  end

end
