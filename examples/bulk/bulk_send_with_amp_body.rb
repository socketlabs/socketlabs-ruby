require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class BulkSendWithAmpBody
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Test Message (Bulk Send With AMP Body)"
    message.html_body = "<html><body>" +
                    "<h1>Sending A Test Message</h1>" +
                    "<p>This HTML will show if AMP is not supported on the receiving end of the email.</p>" +
                    "</body></html>"

    message.amp_body = "<!doctype html>" +
        "<html amp4email>" +
        "<head>" +
        "<title>Sending an AMP Test Message</title>" +
        "  <meta charset=\"utf-8\">"+
        "  <script async src=\"https://cdn.ampproject.org/v0.js\"></script>" +
        "  <style amp4email-boilerplate>body{visibility:hidden}</style>" +
        "  <style amp-custom>" +
        "    h1 {" +
        "      margin: 1rem;" +
        "    }" +
        "  </style>" +
        "</head>" +
        "<body>" +
        "       <h1>Sending A Bulk AMP Test Message</h1>" +
        "       <h2>Merge Data</h2>" +
        "       <p>" +
        "           Motto = <b>%%Motto%%</b> </br>" +
        "           Birthday = <b>%%Birthday%%</b> </br>" +
        "           Age = <b>%%Age%%</b> </br>" +
        "           UpSell = <b>%%UpSell%%</b>" +
        "       </p>" +
        "       <h2>Example of Merge Usage</h2>" +
        "       <p>" +
        "           Our company motto is '<b>%%Motto%%</b>'. </br>" +
        "           Your birthday is <b>%%Birthday%%</b> and you are <b>%%Age%%</b> years old." +
        "       </p>" +
        "       <h2>UTF-8 Characters:</h2>" +
        "       <p>✔ - Check</p>" +
        "       </body>" +
        "       </html>"


    message.from_email_address = EmailAddress.new("from@example.com")

    message.add_to_recipient("recipient1@example.com")
    message.add_to_recipient("recipient2@example.com", "Recipient #2")
    message.add_to_recipient(BulkRecipient.new("recipient3@example.com"))
    message.add_to_recipient(BulkRecipient.new("recipient4@example.com", {:friendly_name => "Recipient #4"}))

    message

  end

end
