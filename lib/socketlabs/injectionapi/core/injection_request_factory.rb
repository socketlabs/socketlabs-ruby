require_relative '../message/message_base.rb'
require_relative '../message/basic_message.rb'
require_relative '../message/email_address.rb'
require_relative '../message/bulk_message.rb'
require_relative '../message/bulk_recipient.rb'
require_relative '../message/custom_header.rb'

require_relative 'serialization/address_json.rb'
require_relative 'serialization/attachment_json.rb'
require_relative 'serialization/custom_header_json.rb'
require_relative 'serialization/message_json.rb'
require_relative 'serialization/merge_data_json.rb'

module SocketLabs
  module InjectionApi
    module Core
      class InjectionRequestFactory
        include SocketLabs::InjectionApi
        include SocketLabs::InjectionApi::Core
        include SocketLabs::InjectionApi::Message
        include SocketLabs::InjectionApi::Core::Serialization

        attr_reader :server_id
        attr_reader :api_key

        # Creates a new instance of the InjectionRequestFactory.
        # @param [String] server_id
        # @return [String] api_key
        def initialize(server_id, api_key)

          @server_id = server_id
          @api_key = api_key

        end

        # Generate the InjectionRequest for sending to the Injection Api.
        # @param [BasicMessage, BulkMessage] message: the message object to convert
        # @return [InjectionRequest] the converted InjectionRequest
        def generate_request(message)

          request = InjectionRequest.new

          if message.instance_of? BasicMessage
            request = generate_basic_message_request(message)
          end

          if message.instance_of? BulkMessage
            request = generate_bulk_message_request(message)
          end

          request

        end

        private
        # Converts MessageBase object to a MessageJson object
        # @param [MessageBase] message: the message to convert
        # @return [MessageJson] the convert MessageJson object
        def generate_base_message(message)

          message_json = MessageJson.new
          message_json.subject = message.subject
          message_json.plain_text_body = message.plain_text_body
          message_json.html_body = message.html_body
          message_json.mailing_id = message.mailing_id
          message_json.message_id = message.message_id
          message_json.charset = message.charset
          message_json.from_email_address = email_address_to_address_json(message.from_email_address)
          message_json.custom_headers = populate_custom_headers(message.custom_headers)
          message_json.attachments = populate_attachments(message.attachments)

          unless message.api_template.nil?
              message_json.api_template = message.api_template
          end
          unless message.reply_to_email_address.nil?
              message_json.reply_to = email_address_to_address_json(message.reply_to_email_address)
          end
          message_json

        end

        # Converts a list of Attachment objects to a List of AttachmentJson objects.
        # @param [Array] custom_headers: list of CustomHeader to convert
        # @return [Array] the converted list of CustomHeaderJson
        def populate_custom_headers(custom_headers)

          if custom_headers.nil? || custom_headers.empty?
            nil
          end

          headers_json = Array.new

          custom_headers.each do |header|
            if header.instance_of? CustomHeader
              headers_json.push(CustomHeaderJson.new(header.name, header.value))
            elsif header.instance_of? Hash
              headers_json.push(CustomHeaderJson.new(header[:name], header[:value]))
            end
          end

          headers_json

        end

        # Converts a list of Attachment objects to a List of AttachmentJson objects.
        # @param [Attachment] attachments: list of Attachment to convert
        # @return [Array] the converted list of AttachmentJson
        def populate_attachments(attachments)

          if attachments.nil? || attachments.empty?
            nil
          end

          attachments_json = Array.new

          attachments.each do |item|
            if item.instance_of? Attachment

              at_json = AttachmentJson.new
              at_json.name = item.name
              at_json.name = item.name
              at_json.mime_type = item.mime_type
              at_json.content_id = item.content_id
              at_json.content = item.content
              at_json.custom_headers = populate_custom_headers(item.custom_headers)

              attachments_json.push(at_json)
            end
          end

          attachments_json

        end


        # Generate the InjectionRequest for sending to the Injection Api.
        # @param [BasicMessage] message: the basic message object to convert
        # @return [InjectionRequest] the converted InjectionRequest
        def generate_basic_message_request(message)

          message_json = generate_base_message(message)

          unless message.to_email_address.nil? || message.to_email_address.empty?
            message_json.to_email_address = populate_email_list(message.to_email_address)
          end

          unless message.cc_email_address.nil? || message.cc_email_address.empty?
            message_json.cc_email_address = populate_email_list(message.cc_email_address)
          end

          unless message.bcc_email_address.nil? || message.bcc_email_address.empty?
            message_json.bcc_email_address = populate_email_list(message.bcc_email_address)
          end

          messages_json = []
          messages_json.push(message_json)

          InjectionRequest.new(@server_id, @api_key, messages_json)

        end

        # Converts a List of EmailAddress objects to a List of AddressJson objects.
        # @param [EmailAddress] addresses: list of EmailAddress to convert
        # @return [Array] of AddressJson - the converted list of AddressJson
        def populate_email_list(addresses)

          if addresses.nil? || addresses.empty?
            nil
          end

          addresses_json = Array.new

          unless addresses.nil? || addresses.empty?
            addresses.each do |email|
              if email.instance_of? EmailAddress
                addresses_json.push(email_address_to_address_json(email))

              elsif email.instance_of? String
                str_email = EmailAddress.new(email)
                addresses_json.push(email_address_to_address_json(str_email))

              elsif email.instance_of? Hash
                hash_email = EmailAddress.new(email[:email_address], email[:friendly_name])
                addresses_json.push(email_address_to_address_json(hash_email))
              end
            end
          end

          addresses_json

        end

        # Simple converter from EmailAddress to AddressJson
        # @param [EmailAddress] address: the EmailAddress object to convert
        # @return [AddressJson] the converted AddressJson object
        def email_address_to_address_json(address)

          unless address.friendly_name.nil? || address.friendly_name.empty?
            AddressJson.new(address.email_address, address.friendly_name)
          else
            AddressJson.new(address.email_address)
          end

        end

        # Generate the InjectionRequest for sending to the Injection Api.
        # @param [BulkMessage] message: the bulk message object to convert
        # @return [InjectionRequest] the converted InjectionRequest
        def generate_bulk_message_request(message)

          message_json = generate_base_message(message)
          message_json.to_email_address.push(AddressJson.new("%%DeliveryAddress%%", "%%RecipientName%%"))
          message_json.merge_data = populate_merge_data(message.global_merge_data, message.to_recipient)

          messages_json = []
          messages_json.push(message_json)

          InjectionRequest.new(@server_id, @api_key, messages_json)

        end

        # Simple converter from BulkRecipient to AddressJson
        # @param [BulkRecipient] address: the BulkRecipient object to convert
        # @return [AddressJson] the converted AddressJson object
        def bulk_recipient_to_address_json(address)

          if address.friendly_name.nil? || address.friendly_name.empty?
            AddressJson.new(address.email_address)
          else
            AddressJson.new(address.email_address, address.friendly_name)
          end

        end

        # Populates global merge data and per message merge data to a MergeDataJson.
        # @param [Array] global_md: array of global merge data to convert
        # @param [Array] recipients: list of BulkRecipients to convert
        # @return [MergeDataJson] the converted MergeDataJson object
        def populate_merge_data(global_md, recipients)

          per_message_mf = Array.new
          global_mf = generate_merge_field_list(global_md)

          unless recipients.nil? || recipients.empty?
            recipients.each do |email|

              if email.instance_of? BulkRecipient
                recipient = email

              elsif email.instance_of? String
                recipient = BulkRecipient.new(email)

              elsif email.instance_of? Hash
                recipient = BulkRecipient.new(email[:email_address], { :friendly_name => email[:friendly_name], :merge_data => email[:merge_data] })

              end

              merge_field_json = generate_merge_field_list(recipient.merge_data)
              merge_field_json.push(MergeFieldJson.new("DeliveryAddress", recipient.email_address))

              unless recipient.friendly_name.nil? || recipient.friendly_name.empty?
                merge_field_json.push(MergeFieldJson.new("RecipientName", recipient.friendly_name))
              end

              per_message_mf.push(merge_field_json)

            end
          end

          MergeDataJson.new(per_message_mf, global_mf)

        end

        # Converts an Array of merge data into a List of MergeFieldJson objects.
        # @param [Array] merge_data: Array to convert
        # @return [Array] the converted list of MergeFieldJson
        def generate_merge_field_list(merge_data)

          merge_field_json = Array.new

          merge_data.each do |item|

            if item.instance_of? MergeData
              json = MergeFieldJson.new(item.key, item.value)
              merge_field_json.push(json)

            elsif item.instance_of? Hash
              json = MergeFieldJson.new(item[:key], item[:value])
              merge_field_json.push(json)
            end
          end

          merge_field_json

        end

      end
    end
  end
end