require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BulkSendWithAsciiCharsetMergeData
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Test Message With ASCII Charset Merge Data"

    # Set HTML and plain text body, both of which use UTF-8 characters
    # Build the Content (Note the %% symbols used to denote the data to be merged)
    message.html_body = "<html>" +
        "   <body>" +
        "       <h1>Sending A Test Message With ASCII Charset Merge Data</h1>" +
        "       <h2>Merge Data</h2>" +
        "       <p>Complete? = %%Complete%%</p>" +
        "   </body>" +
        "</html>"
    message.plain_text_body = "Sending A Test Message With ASCII Charset Merge Data" +
        "       Merged Data" +
        "           Complete? = %%Complete%%"

    message.from_email_address = EmailAddress.new("from@example.com")

    # set the charset
    message.charset = "ASCII"

    message.add_global_merge_data("Complete", "{ no response }")

    # Add recipients with merge data that contains UTF-8 characters
    recipient = BulkRecipient.new("recipient1@example.com")
    recipient.add_merge_data("Complete", "✘")
    message.add_to_recipient(recipient)

    recipient = BulkRecipient.new("recipient2@example.com", { :friendly_name => "Recipient #2" })
    recipient.add_merge_data("Complete", "✔")
    message.add_to_recipient(recipient)

    recipient = BulkRecipient.new("recipient3@example.com")
    recipient.add_merge_data("Complete", "✘")
    message.add_to_recipient(recipient)

    message.add_to_recipient(BulkRecipient.new("recipient4@example.com", { :friendly_name => "Recipient #4"}))

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

res = BulkSendWithAsciiCharsetMergeData.new.execute