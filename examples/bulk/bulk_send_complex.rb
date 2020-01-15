require_relative "../../lib/socketlabs-ruby.rb"
require "json"

class BulkSendComplex
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  private
  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Complex Test Message (Bulk Send))"
    message.html_body ="<html>" +
        "   <head><title>Sending A Complex Test Message</title></head>" +
        "   <body>" +
        "       <h1>Sending A Complex Test Message</h1>" +
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
        "       <h2>Embedded Image:</h2>" +
        "       <p><img src='cid:bus' /></p>" +
        "   </body>" +
        "</html>"

    message.plain_text_body = "Sending A Complex Test Message" +
        "       Merged Data" +
        "           Motto = %%Motto%%" +
        "           Birthday = %%Birthday%%" +
        "           Age = %%Age%%" +
        "           UpSell = %%UpSell%%" +
        "       " +
        "       Example of Merge Usage" +
        "           Our company motto is '%%Motto%%'." +
        "           Your birthday is %%Birthday%% and you are %%Age%% years old."

    message.message_id = "ComplexExample"
    message.mailing_id = "BulkSend"
    message.charset = "UTF-8"

    message.from_email_address = EmailAddress.new("from@example.com")
    message.reply_to_email_address = EmailAddress.new("replyto@example.com")

    # Add some global merge-data
    # (These will be applied to all Recipients unless specifically overridden by Recipient level merge data)
    # --------
    # Add global merge data using a Array
    global_merge_data = Array.new
    # EmailAddress object in array
    global_merge_data.push(MergeData.new("Birthday", "unknown"))
    # hash in array
    global_merge_data.push({ :key => "Motto", :value => "When hitting the inbox matters!" })

    message.global_merge_data = global_merge_data

    # Add Email Addresses directly to the Array
    # EmailAddress object in array
    message.global_merge_data.push(MergeData.new("Age", "an unknown number of"))
    # hash in array
    message.global_merge_data.push({ :key => "This wont show.", :value =>  "No Text" })

    # Add global merge data using the add_global_merge_data function
    message.add_global_merge_data("UpSell", "BTW:  You are eligible for discount pricing when you upgrade your service!")


    # Add recipients with merge data
    # Including merge data on the recipient with the same name as the global merge data will override global merge data
    # --------
    # Add recipients with merge data using an Array
    rec1_merge_data = Array.new
    rec1_merge_data.push(MergeData.new("Birthday", "08/05/1991"))
    rec1_merge_data.push(MergeData.new("Age", "27"))
    rec1 = BulkRecipient.new("recipient1@example.com", { :merge_data => rec1_merge_data })
    message.to_recipient.push(rec1)

    # Add recipients with merge data using the add_to_recipient function
    rec2_merge_data = Array.new
    rec2_merge_data.push(MergeData.new("Birthday", "04/12/1984"))
    rec2_merge_data.push(MergeData.new("UpSell", ""))
    rec2_merge_data.push({ key: "Age", value: "34" })
    message.add_to_recipient("recipient2@example.com", "Recipient #2", rec2_merge_data)

    # Add recipients with merge data directly to the Array using a Hash
    message.to_recipient.push({
                                  :email_address => "recipient3@example.com",
                                  :friendly_name => "Recipient 3",
                                  :merge_data => [
                                      { :key => "Birthday", :value => "10/30/1978" },
                                      { :key => "UpSell", :value => "" },
                                      { :key => "Age", :value => "40" }
                                  ]
                              })

    # Add recipients using the addToRecipient function
    # The merge data for this Recipient will be populated with Global merge data
    message.add_to_recipient("recipient4@example.com", "Recipient #4")

    # Adding Custom Headers
    # --------
    # Add CustomHeader using a list
    headers = Array.new
    headers.push(CustomHeader.new("example-type", "basic-send-complex-example"))
    headers.push(CustomHeader.new("message-contains", "attachments, headers"))

    message.custom_headers = headers


    # Add CustomHeader directly to the list
    message.custom_headers.push(CustomHeader.new("message-has-attachments", "true"))

    # Add CustomHeader using the add_custom_header function
    message.add_custom_header("testMessageHeader", "I am a message header")
    message.add_custom_header(CustomHeader.new("testMessageHeader2", "I am another message header"))

    # Adding Attachments
    attachment1 = Attachment.new(
        name:"bus",
        file_path:"../img/bus.png",
        mime_type:"image/png"
    )
    message.attachments.push(attachment1)

    # Add Attachment using the add_attachment function
    attachment2 = Attachment.new(
        name:"bus2",
        file_path:"../img/bus.png",
        mime_type:"image/png"
    )
    attachment2.content_id = "bus"
    message.add_attachment(attachment2)

    # Add Attachment a filePath {string} to the array
    message.add_attachment(Attachment.new(file_path:"../html/SampleEmail.html"))

    # Add Attachment using bytes of the file
    file_path = "../img/bus.png"
    file = File.open(file_path, "rb")
    data = Base64.encode64(file.read)

    attachment4 = Attachment.new(
        name: "yellow-bus.png",
        mime_type: "image/png",
        content: data
    )

    # Add CustomHeaders to Attachment
    attachment4.custom_headers.push(CustomHeader.new("Color", "Yellow"))
    attachment4.add_custom_header("Place", "Beach")

    message.add_attachment(attachment4)

    message

  end

  public
  def execute

    message = get_message
    puts message

    validator = SendValidator.new
    result = validator.validate_message(message)
    puts result

    factory = InjectionRequestFactory.new(10000, "abcdefgxyz")
    factory.generate_request(message)


    SocketLabsClient.new(10000, "abcdefgxyz")

    # with proxy
    # SocketLabsClient.new(10000, "abcdefgxyz", Proxy.new("", 0000))

    # json = message.as_json
    # puts JSON.pretty_generate(json)

  end

end

res = BulkSendComplex.new.execute