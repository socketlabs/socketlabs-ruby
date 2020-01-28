require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BulkSendWithMergeData
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Test Message With Merge Data"
    message.html_body = "<html>" +
                     "   <head><title>Sending A Test Message With Merge Data</title></head>" +
                     "   <body>" +
                     "       <h1>Sending A Complex Test Message</h1>" +
                     "       <h2>Global Merge Data</h2>" +
                     "       <p>Motto = <b>%%Motto%%</b></p>" +
                     "       <h2>Per Recipient Merge Data</h2>" +
                     "       <p>" +
                     "       EyeColor = %%EyeColor%%<br/>" +
                     "       HairColor = %%HairColor%%" +
                     "       </p>" +
                     "   </body>" +
                     "</html>"
    message.plain_text_body = "Sending A Test Message With Merge Data" +
                     "       Merged Data" +
                     "           Motto = %%Motto%%" +
                     "       " +
                     "       Example of Merge Usage" +
                     "           EyeColor = %%EyeColor%%" +
                     "           HairColor = %%HairColor%%"

    message.from_email_address = EmailAddress.new("from@example.com")

    # Add some global merge-data (These will be applied to all Recipients
    # unless specifically overridden by Recipient level merge-data)
    message.add_global_merge_data("EyeColor", "{ not set }")
    message.add_global_merge_data("HairColor", "{ not set }")
    message.add_global_merge_data("Motto", "When hitting the Inbox matters!")

    # Add recipients with merge data
    recipient = BulkRecipient.new("recipient1@example.com")
    recipient.add_merge_data("EyeColor", "Blue")
    recipient.add_merge_data("HairColor", "Blond")
    message.add_to_recipient(recipient)

    recipient = BulkRecipient.new("recipient2@example.com", { :friendly_name => "Recipient #2" })
    recipient.add_merge_data("EyeColor", "Green")
    message.add_to_recipient(recipient)

    recipient = BulkRecipient.new("recipient3@example.com")
    recipient.add_merge_data("HairColor", "Brown")
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

res = BulkSendWithMergeData.new.execute