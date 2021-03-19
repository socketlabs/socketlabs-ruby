require_relative "../lib/socketlabs-injectionapi.rb"

require_relative "basic/basic_send.rb"
require_relative "basic/basic_send_complex.rb"
require_relative "basic/basic_send_from_html_file.rb"
require_relative "basic/basic_send_with_api_template.rb"
require_relative "basic/basic_send_with_ascii_charset.rb"
require_relative "basic/basic_send_with_attachment.rb"
require_relative "basic/basic_send_with_custom_headers.rb"
require_relative "basic/basic_send_with_embedded_image.rb"
require_relative "basic/basic_send_with_proxy.rb"
require_relative "basic/invalid/basic_send_with_invalid_attachment"
require_relative "basic/invalid/basic_send_with_invalid_from"
require_relative "basic/invalid/basic_send_with_invalid_recipients"
require_relative "bulk/bulk_send.rb"
require_relative "bulk/bulk_send_complex.rb"
require_relative "bulk/bulk_send_from_data_source_with_merge_data.rb"
require_relative "bulk/bulk_send_with_ascii_charset_merge_data.rb"
require_relative "bulk/bulk_send_with_merge_data.rb"
require_relative "basic/basic_send_with_amp_body"
require_relative 'bulk/bulk_send_with_amp_body'

require "json"

class ExampleRunner
  include SocketLabs::InjectionApi
  include SocketLabs::InjectionApi::Core
  include SocketLabs::InjectionApi::Message

  def self.display_menu
    puts ""
    puts "Please select from one of the following code examples:"
    puts "NOTE:  Please update the your environment variables with your credentials"
    puts ""
    puts " Basic Send Examples: "
    puts "    1:  Basic Send "
    puts "    2:  Basic Send From Html File "
    puts "    3:  Basic Send With Api Template "
    puts "    4:  Basic Send With Ascii Charset "
    puts "    5:  Basic Send With Attachment "
    puts "    6:  Basic Send With Custom-Headers "
    puts "    7:  Basic Send With Embedded Image "
    puts "    8:  Basic Send With Proxy "
    puts "    9:  Basic Send Complex Example "
    puts "   10:  Basic Send With AMP Body"
    puts ""
    puts " Validation Error Handling Examples: "
    puts "   11:  Basic Send With Invalid Attachment"
    puts "   12:  Basic Send With Invalid From "
    puts "   13:  Basic Send With Invalid Recipients "
    puts ""
    puts " Bulk Send Examples: "
    puts "   14:  Bulk Send "
    puts "   15:  Bulk Send With MergeData "
    puts "   16:  Bulk Send With Ascii Charset And MergeData "
    puts "   17:  Bulk Send From DataSource With MergeData "
    puts "   18:  Bulk Send Complex Example (Everything including the Kitchen Sink) "
    puts "   19:  Bulk Send With AMP Body"
    puts ""
    puts "-------------------------------------------------------------------------"

  end

  def self.execute(message, use_proxy = false)

    # Add live emails to the test messages
    # message.from_email_address = EmailAddress.new("yourname@example.com")

    if message.instance_of? BasicMessage
      # message.add_to_email_address("yourname@example.com")
    end

    if message.instance_of? BulkMessage
      # message.add_to_recipient("yourname@example.com")
    end

    puts message

    server_id = ENV['SOCKETLABS_SERVER_ID']
    api_key = ENV['SOCKETLABS_INJECTION_API_KEY']

    # create the proxy hash. accepted values: :host, :port, :user, :pass
    if use_proxy
      proxy = { :host =>"127.0.0.1", :port => 4433 }
    else
      proxy = {}
    end

    client = SocketLabsClient.new(server_id, api_key, proxy)
    client.request_timeout = 10
    begin
      response = client.send(message)
      puts response.to_json
    rescue => e
      puts "Exception Found (#{ e.class.name }) :: #{ e.message }"
    end

  end

  def self.start_console

    ExampleRunner.display_menu

    loop do
      message = nil
      use_proxy = false
      puts "Enter a number (or QUIT to exit):"

      input = gets.chomp
      command, *params = input.split /\s/

      case command.downcase
      when '1'
        message = BasicSend.new.get_message
      when '2'
        message = BasicSendFromHtmlFile.new.get_message
      when '3'
        message = BasicSendWithApiTemplate.new.get_message
      when '4'
        message = BasicSendWithAsciiCharset.new.get_message
      when '5'
        message = BasicSendWithAttachment.new.get_message
      when '6'
        message = BasicSendWithCustomHeaders.new.get_message
      when '7'
        message = BasicSendWithEmbeddedImage.new.get_message
      when '8'
        message = BasicSendWithProxy.new.get_message
        use_proxy = true
      when '9'
        message = BasicSendComplex.new.get_message
      when '10'
        message = BasicSendWithAmpBody.new.get_message
      when '11'
        message = BasicSendWithInvalidAttachment.new.get_message
      when '12'
        message = BasicSendWithInvalidFrom.new.get_message
      when '13'
        message = BasicSendWithInvalidRecipients.new.get_message
      when '14'
        message = BulkSend.new.get_message
      when '15'
        message = BulkSendWithMergeData.new.get_message
      when '16'
        message = BulkSendWithAsciiCharsetMergeData.new.get_message
      when '17'
        message = BulkSendFromDataSourceWithMergeData.new.get_message
      when '18'
        message = BulkSendComplex.new.get_message
      when '19'
        message = BulkSendWithAmpBody.new.get_message
      when 'quit'
        break
      else
        puts 'Invalid Input (Out of Range)'
      end

      unless message.nil?
        ExampleRunner.execute(message, use_proxy)
      end
    end

  end

end

ExampleRunner.start_console
