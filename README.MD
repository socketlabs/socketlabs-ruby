[![SocketLabs](https://static.socketlabs.com/logos/logo-dark-326x64.png)](https://www.socketlabs.com/developers)
# [![Twitter Follow](https://img.shields.io/twitter/follow/socketlabs.svg?style=social&label=Follow)](https://twitter.com/socketlabs) [![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/socketlabs/socketlabs-nodejs/blob/master/CONTRIBUTING.md)

The SocketLabs Email Delivery Ruby library allows you to easily send email messages via the [SocketLabs Injection API](https://www.socketlabs.com/docs/inject/).  The library makes it easy to build and send any type of message supported by the API, from a simple message to a single recipient all the way to a complex bulk message sent to a group of recipients with unique merge data per recipient.

# Table of Contents
* [Prerequisites and Installation](#prerequisites-and-installation)
* [Getting Started](#getting-started)
* [Managing API Keys](#managing-api-keys)
* [Examples and Use Cases](#examples-and-use-cases)
* [License](#license)


<a name="prerequisites-and-installation" id="prerequisites-and-installation"></a>
# Prerequisites and Installation
## Prerequisites
* A supported Ruby version (3.1 and above)
* A SocketLabs account. If you don't have one yet, you can [sign up for a free account](https://signup.socketlabs.com/step-1?plan=free) to get started.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'socketlabs-injectionapi'
```
And then execute:

    $ bundle install

Install it yourself as:

    $ gem install socketlabs-injectionapi

Or From git

    $ gem 'socketlabs-injectionapi', :git => "https://github.com/socketlabs/socketlabs-ruby.git"


For more information please see the [Installing Gems](https://guides.rubygems.org/rubygems-basics/) tutorial

<a name="getting-started" id="getting-started"></a>
# Getting Started
## Obtaining your API Key and SocketLabs ServerId number
In order to get started, you'll need to enable the Injection API feature in the [SocketLabs Control Panel](https://cp.socketlabs.com).
Once logged in, navigate to your SocketLabs server's dashboard (if you only have one server on your account you'll be taken here immediately after logging in).
Make note of your 4 or 5 digit ServerId number, as you'll need this along with
your API key in order to use the Injection API.

To enable the Injection API, click on the "For Developers" dropdown on the top-level navigation, then choose the "Configure HTTP Injection API" option.
Once here, you can enable the feature by choosing the "Enabled" option in the
dropdown. Enabling the feature will also generate your API key, which you'll
need (along with your ServerId) to start using the API. Be sure to click the
"Update" button to save your changes once you are finished.


## Basic Message
A basic message is an email message like you'd send from a personal email client such as Outlook.
A basic message can have many recipients, including multiple To addresses, CC addresses, and even BCC addresses.
You can also send a file attachment in a basic message.

```ruby
require "socketlabs-injectionapi"

include SocketLabs::InjectionApi
include SocketLabs::InjectionApi::Message

message = BasicMessage.new

message.subject = "Sending A Basic Message"
message.html_body = "<html>This is the Html Body of my message.</html>"
message.plain_text_body = "This is the Plain Text Body of my message."

message.from_email_address = EmailAddress.new("from@example.com")

# A basic message supports up to 50 recipients
# and supports several different ways to add recipients

# Add a To address by passing the email address
message.to_email_address.push("recipient1@example.com")
message.to_email_address.push(EmailAddress.new("recipient2@example.com", "Recipient #2"))

# // Adding CC Recipients
message.add_cc_email_address("recipient3@example.com")
message.add_cc_email_address("recipient4@example.com", "Recipient #4")

# Adding Bcc Recipients
message.add_bcc_email_address(EmailAddress.new("recipient5@example.com"))
message.add_bcc_email_address(EmailAddress.new("recipient6@example.com", "Recipient #6"))

# Your SocketLabs ServerId and Injection API key
client = SocketLabsClient.new(10000, "YOUR-API-KEY")

response = client.send(message)
```

## Bulk Message
A bulk message usually contains a single recipient per message
and is generally used to send the same content to many recipients,
optionally customizing the message via the use of MergeData.
For more information about using Merge data, please see the [Injection API documentation](https://www.socketlabs.com/docs/inject/).
```ruby
require "socketlabs-injectionapi"

include SocketLabs::InjectionApi
include SocketLabs::InjectionApi::Message

# Your SocketLabs ServerId and Injection API key
client = SocketLabsClient.new(10000, "YOUR-API-KEY")

message = BulkMessage.new

message.subject = "Sending A Bulk Message"
message.plain_text_body = "This is the body of my message sent to %%Name%%"
message.html_body = "<html>This is the HtmlBody of my message sent to %%Name%%</html>"

message.from_email_address = EmailAddress.new("from@example.com")

    message.add_global_merge_data("HairColor", "{ not set }")

recipient1 = BulkRecipient.new("recipient1@example.com")
recipient1.add_merge_data("Name", "Recipient1")
message.add_to_recipient(recipient1)

recipient2 = BulkRecipient.new("recipient2@example.com", { :friendly_name => "Recipient #2" })
recipient2.add_merge_data("Name", "Recipient2")
message.add_to_recipient(recipient2)

response = client.send(message)
```

<a name="managing-api-keys" id="managing-api-keys"></a>
## Managing API Keys
For ease of demonstration, many of our examples include the ServerId (SOCKETLABS_SERVER_ID) and API key
(SOCKETLABS_INJECTION_API_KEY) directly in our code sample. Generally it is not considered a good practice to store
sensitive information like this directly in your code. Depending on your project type, we recommend either storing your
credentials using Environment Variables. For more information please see:
[Using Environment Variables](https://docs.microsoft.com/en-us/dotnet/api/system.environment.getenvironmentvariable)


<a name="examples-and-use-cases" id="examples-and-use-cases"></a>
# Examples and Use Cases
In order to demonstrate the many possible use cases for the SDK, we've provided
an assortment of code examples. These examples demonstrate many different
features available to the Injection API and SDK, including using templates
created in the [SocketLabs Email Designer](https://www.socketlabs.com/blog/introducing-new-email-designer/), custom email headers, sending
attachments, sending content that is stored in an HTML file, advanced bulk
merging, and even pulling recipients from a datasource.

### [Basic send example](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send.rb)
This example demonstrates a Basic Send.

### [Basic send complex example](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_complex.rb)
This example demonstrates many features of the Basic Send, including adding multiple recipients, adding message and mailing id's, and adding an embedded image.

### [Basic send from HTML file](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_from_html_file.rb)
This example demonstrates how to read in your HTML content from an HTML file
rather than passing in a string directly.

### [Basic send from SocketLabs Template](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_api_template.rb)
This example demonstrates the sending of a piece of content that was created in the
SocketLabs Email Designer. This is also known as the [API Templates](https://www.socketlabs.com/blog/introducing-api-templates/) feature.

### [Basic send with specified character set](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_ascii_charset.rb)
This example demonstrates sending with a specific character set.

### [Basic send with file attachment](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_attachment.rb)
This example demonstrates how to add a file attachment to your message.

### [Basic send with custom email headers](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_custom_headers.rb)
This example demonstrates how to add custom headers to your email message.

### [Basic send with embedded image](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_embedded_image.rb)
This example demonstrates how to embed an image in your message.

### [Basic send with a web proxy](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_proxy.rb)
This example demonstrates how to use a proxy with your HTTP client.

### [Basic send with retry enabled](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_retry.rb)
This example demonstrates how to use the retry logic with your HTTP client.

### [Basic send with Amp ](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/basic_send_with_amp_body.rb)
This example demonstrates how to send a basic message with an AMP Html body.
For more information about AMP please see [AMP Project](https://amp.dev/documentation/)

### [Basic send with invalid file attachment](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/invalid/basic_send_with_invalid_attachment.rb)
This example demonstrates the results of attempting to do a send with an invalid attachment.

### [Basic send with invalid from address](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/invalid/basic_send_with_invalid_from.rb)
This example demonstrates the results of attempting to do a send with an invalid from address.

### [Basic send with invalid recipients](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/basic/invalid/basic_send_with_invalid_recipients.rb)
This example demonstrates the results of attempting to do a send with invalid recipients.

### [Bulk send with multiple recipients](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send.rb)
This example demonstrates how to send a bulk message to multiple recipients.

### [Bulk send with merge data](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send_with_merge_data.rb)
This example demonstrates how to send a bulk message to multiple recipients with
unique merge data per recipient.

### [Bulk send with complex merge including attachments](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send_complex.rb)
This example demonstrates many features of the `BulkMessage()`, including
adding multiple recipients, merge data, and adding an attachment.

### [Bulk send with recipients pulled from a datasource](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send_from_data_source_with_merge_data.rb)
This example uses a mock repository class to demonstrate how you would pull
your recipients from a database and create a bulk mailing with merge data.

### [Bulk send with Ascii charset and special characters](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send_with_ascii_charset_merge_data.rb)
This example demonstrates how to send a bulk message with a specified character
set and special characters.

### [Bulk send with Amp ](https://github.com/socketlabs/socketlabs-ruby/blob/master/examples/bulk/bulk_send_with_amp_body.rb )
This example demonstrates how to send a bulk message with an AMP Html body.
For more information about AMP please see [AMP Project](https://amp.dev/documentation/)

<a name="version"></a>
# Version
* 1.4.4 - Added MetadataOrTagsAreTooLarge error messsage
* 1.4.2 - Adding API Key Authorization
* 1.4.0 - Adding Metadata and Tags
* 1.2.1 - Adding optional retry logic for Http requests. If configured, the request will retry when certain 500 errors occur (500, 502, 503, 504)
* 1.1.1 - Adding request timeout value on the client for Http requests
* 1.1.0 - Adds Amp Html Support
* 1.0.0 - Initial Release

<a name="license" id="license"></a>
# License
The SocketLabs.EmailDelivery library and all associated code, including any code samples, are [MIT Licensed](https://github.com/socketlabs/socketlabs-python/blob/master/LICENSE.MD).