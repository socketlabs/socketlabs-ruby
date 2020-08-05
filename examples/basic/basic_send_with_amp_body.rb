require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BasicSendWithAmpBody
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BasicMessage.new

    message.subject = "Sending A Test Message (Basic Send With AMP Body)"
    message.html_body = "<html>" +
        "<body>" +
        "<h1>Sending A Test Message</h1>" +
        "<p>This HTML will show if AMP is not supported on the receiving end of the email.</p>" +
        "</body>" +
        "</html>"

    message.amp_body ="<!doctype html>" +
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


    message.from_email_address = EmailAddress.new("from@example.com")

    message.add_to_email_address("recipient1@example.com")
    message.add_to_email_address("recipient2@example.com", "Recipient #2")
    message.add_to_email_address(EmailAddress.new("recipient3@example.com"))
    message.add_to_email_address(EmailAddress.new("recipient4@example.com", "Recipient #4"))

    message
  end

end
