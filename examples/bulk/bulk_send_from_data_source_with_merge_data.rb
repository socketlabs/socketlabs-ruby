require_relative "../../lib/socketlabs-injectionapi.rb"
require "json"

class Customer
  attr_accessor :first_name, :last_name, :email_address, :favorite_color

  def initialize(
      first,
      last,
      email,
      color
  )
    @first_name = first
    @last_name = last
    @email_address = email
    @favorite_color = color
  end

end
class CustomerRepository

  def self.get_customers
    [
        Customer.new("Recipient", "One", "recipient1@example.com", "Green"),
        Customer.new("Recipient", "Two", "recipient2@example.com", "Red"),
        Customer.new("Recipient", "Three", "recipient3@example.com", "Blue"),
        Customer.new("Recipient", "Four", "recipient4@example.com", "Orange")
    ]

  end

end

class BulkSendFromDataSourceWithMergeData
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def get_message

    message = BulkMessage.new

    message.subject = "Sending A Test Message With Merge Data From Datasource"
    message.html_body =  "<html>" +
                     "   <body>" +
                     "       <h1>Sending A Test Message With Merge Data From Datasource</h1>" +
                     "       <h2>Hello %%FirstName%% %%LastName%%.</h2>" +
                     "       <p>Is your favorite color still %%FavoriteColor%%?</p>" +
                     "   </body>" +
                     "</html>"

    message.plain_text_body =  "Sending A Test Message With Merge Data From Datasource" +
                     "       Hello %%FirstName%% %%LastName%%. Is your favorite color still %%FavoriteColor%%?"

    message.from_email_address = EmailAddress.new("from@example.com")

    customers = CustomerRepository.get_customers

    customers.each do |customer|
      recipient = BulkRecipient.new(customer.email_address, { :friendly_name => "#{customer.first_name} #{customer.last_name}" })
      recipient.add_merge_data("FirstName", customer.first_name)
      recipient.add_merge_data("LastName", customer.last_name)
      recipient.add_merge_data("FavoriteColor", customer.favorite_color)

      message.add_to_recipient(recipient)
    end

    message

  end

end
