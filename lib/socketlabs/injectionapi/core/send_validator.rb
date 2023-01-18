require_relative '../message/message_base.rb'
require_relative '../message/basic_message.rb'
require_relative '../message/email_address.rb'
require_relative '../message/bulk_message.rb'
require_relative '../message/bulk_recipient.rb'
require_relative '../message/custom_header.rb'
require_relative '../message/metadata.rb'

module SocketLabs
  module InjectionApi
    module Core

      # Used by the SocketLabsClient to conduct basic validation on the message before sending to the Injection API.
      class SendValidator
        include SocketLabs::InjectionApi
        include SocketLabs::InjectionApi::Message

        public
        # Validate a basic email message before sending to the Injection API.
        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_message(message)

          result = SendResponse.new

          if message.instance_of? BasicMessage
            result = validate_basic_message(message)
          end

          if message.instance_of? BulkMessage
            result = validate_bulk_message(message)
          end

          result

        end

        # Validate the ServerId and Api Key pair prior before sending to the Injection API.
        # @param [Integer] server_id
        # @param [String] api_key
        # @return [SendResponse]
        def validate_credentials(server_id, api_key)

          if api_key.nil? || api_key.empty?
            SendResponse.new(result=SendResult.enum["AuthenticationValidationFailed"])
          end

          if server_id.nil? || (!server_id.is_a?(Integer) && server_id.empty?)
            SendResponse.new(result=SendResult.enum["AuthenticationValidationFailed"])
          end

          SendResponse.new(result=SendResult.enum["Success"])
        end

        private
        # Maximum recipient threshold
        def maximum_recipients_per_message
          50
        end

        # Validate the required fields of a BasicMessage.
        # Fields validated are Subject, From Address, Reply To (if set),
        # Message Body, and Custom Headers (if set)
        # @param [MessageBase] message
        # @return [SendResult]
        def validate_base_message(message)

          unless has_subject(message)
            SendResult.enum["MessageValidationEmptySubject"]
          end
          unless has_from_email_address(message)
            SendResult.enum["EmailAddressValidationMissingFrom"]
          end
          unless message.from_email_address.is_valid
            SendResult.enum["EmailAddressValidationInvalidFrom"]
          end
          unless has_valid_reply_to(message)
            SendResult.enum["RecipientValidationInvalidReplyTo"]
          end
          unless has_message_body(message)
            SendResult.enum["MessageValidationEmptyMessage"]
          end
          unless has_valid_custom_headers(message.custom_headers)
            SendResult.enum["MessageValidationInvalidCustomHeaders"]
          end
          unless has_valid_metadata(message.metadata)
            SendResult.enum["MessageValidationInvalidMetadata"]
          end

          SendResult.enum["Success"]

        end

        # Check if the message has a subject
        # @param [MessageBase] message
        # @return [Boolean]
        def has_subject(message)
          !(message.subject.nil? || message.subject.empty?)
        end

        # Check if the message has a valid From Email Address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_message_body(message)

          if has_api_template(message)
            true
          end

          has_html_body = !(message.html_body.nil? || message.html_body.empty?)
          has_plain_text_body = !(message.plain_text_body.nil? || message.plain_text_body.empty?)

          has_html_body || has_plain_text_body

        end

        # Check if an ApiTemplate was specified and is valid
        # @param [MessageBase] message
        # @return [Boolean]
        def has_api_template(message)
          !(message.api_template.nil?)
        end

        # Check if the message has a valid From Email Address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_from_email_address(message)

          if message.from_email_address.nil?
           false
          end

          !(message.from_email_address.email_address.nil? || message.from_email_address.email_address.empty?)

        end

        # Check if reply_to_email_address is a valid to email address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_valid_reply_to(message)

          unless message.reply_to_email_address.nil?
            message.reply_to_email_address.is_valid
          end

          false

        end

        # Validate email recipients for a basic message
        # Checks the To, Cc, and the Bcc EmailAddress lists for the following:
        #   > At least 1 recipient is in the list.
        #   > Cumulative count of recipients in all 3 lists do not exceed the MaximumRecipientsPerMessage
        #   > Recipients in lists are valid.
        # If errors are found, the SendResponse will contain the invalid email addresses
        # @param [BasicMessage] message
        # @return [Boolean]
        def validate_email_addresses(message)

          rec_count = get_full_recipient_count(message)
          if rec_count <= 0
            SendResponse.new(result=SendResult.enum["RecipientValidationNoneInMessage"])
          end
          if rec_count > maximum_recipients_per_message
            SendResponse.new(result=SendResult.enum["RecipientValidationMaxExceeded"])
          end
          invalid_rec = has_invalid_email_addresses(message)
          unless invalid_rec.nil? || invalid_rec.empty?
            SendResponse.new(result=SendResult.enum["RecipientValidationInvalidRecipients"], address_results=invalid_rec)
          end

          SendResponse.new(result=SendResult.enum["Success"])

        end

        # Validate email recipients for a bulk message
        # Checks the To recipient lists for the following:
        #   > At least 1 recipient is in the list.
        #   > Cumulative count of recipients in all 3 lists do not exceed the MaximumRecipientsPerMessage
        #   > Recipients in lists are valid.
        # If errors are found, the SendResponse will contain the invalid email addresses
        # @param [BulkMessage] message
        # @return [Boolean]
        def validate_recipients(message)

          if message.to_recipient.nil? || message.to_recipient.empty?
            SendResponse.new(result=SendResult.enum["RecipientValidationMissingTo"])
          end
          if message.to_recipient.length > maximum_recipients_per_message
            SendResponse.new(result=SendResult.enum["RecipientValidationMaxExceeded"])
          end
          invalid_rec = has_invalid_recipients(message)
          unless invalid_rec.nil? || invalid_rec.empty?
            SendResponse.new(result=SendResult.enum["RecipientValidationInvalidRecipients"], address_results=invalid_rec)
          end

          SendResponse.new(result=SendResult.enum["Success"])
        end

        # Check all 3 EmailAddress lists To, Cc, and Bcc for valid email addresses
        # @param [BasicMessage] message
        # @return [Boolean]
        def has_invalid_email_addresses(message)

          invalid = Array.new

          invalid_to = find_invalid_email_addresses(message.to_email_address)
          unless invalid_to.nil? || invalid_to.empty?
            invalid.push(*invalid_to)
          end

          invalid_cc = find_invalid_email_addresses(message.cc_email_address)
          unless invalid_cc.nil? || invalid_cc.empty?
            invalid.push(*invalid_cc)
          end

          invalid_bcc = find_invalid_email_addresses(message.bcc_email_address)
          unless invalid_bcc.nil? || invalid_bcc.empty?
            invalid.push(*invalid_bcc)
          end

          if invalid.length > 0
            invalid
          end

          nil

        end

        # Check the To recipient list for valid email addresses
        # @param [BasicMessage] message
        # @return [Boolean]
        def has_invalid_recipients(message)

          invalid = Array.new

          invalid_to = find_invalid_recipients(message.to_recipient)
          unless invalid_to.nil? || invalid_to.empty?
            invalid.push(*invalid_to)
          end

          if invalid.length > 0
            invalid
          end

          nil

        end

        # Check the list of EmailAddress for valid email addresses
        # @param [Array] email_addresses
        # @return [Array]
        def find_invalid_email_addresses(email_addresses)

          invalid = Array.new

          unless email_addresses.nil? || email_addresses.empty?
            email_addresses.each do |email|
              if email.instance_of? EmailAddress
                unless email.is_valid
                  invalid.push(AddressResult.new(email.email_address, false, "InvalidAddress"))
               end

              elsif email.instance_of? String
                str_email = EmailAddress.new(email)
                unless str_email.is_valid
                  invalid.push(AddressResult.new(str_email.email_address, false, "InvalidAddress"))
                end

              elsif email.instance_of? Hash
                hash_email = EmailAddress.new(email[:email_address], email[:friendly_name])
                unless hash_email.is_valid
                  invalid.push(AddressResult.new(hash_email.email_address, false, "InvalidAddress"))
                end
              end
            end
          end

          invalid

        end

        # Check the list of BulkRecipient for valid email addresses
        # @param [Array] recipients
        # @return [Array]
        def find_invalid_recipients(recipients)

          invalid = Array.new

          unless recipients.nil? || recipients.empty?
            recipients.each do |email|

              if email.instance_of? BulkRecipient
                unless email.is_valid
                  invalid.push(AddressResult.new(email.email_address, false, "InvalidAddress"))
                end

              elsif email.instance_of? String
                str_email = BulkRecipient.new(email)
                unless str_email.is_valid
                  invalid.push(AddressResult.new(str_email.email_address, false, "InvalidAddress"))
                end

              elsif email.instance_of? Hash
                hash_email = BulkRecipient.new(email[:email_address], { :friendly_name => email[:friendly_name], :merge_data => email[:merge_data] })
                unless hash_email.is_valid
                  invalid.push(AddressResult.new(hash_email.email_address, false, "InvalidAddress"))
                end
              end

            end
          end

          invalid

        end

        # Cumulative count of email addresses in all 3 EmailAddress lists To, Cc, and Bcc
        # @param [BasicMessage] message
        # @return [Integer]
        def get_full_recipient_count(message)

          recipient_count = 0
          unless message.to_email_address.nil? || message.to_email_address.empty?
            recipient_count += message.to_email_address.length
          end

          unless message.cc_email_address.nil? || message.cc_email_address.empty?
            recipient_count += message.cc_email_address.length
          end

          unless message.bcc_email_address.nil? || message.bcc_email_address.empty?
            recipient_count += message.bcc_email_address.length
          end
          recipient_count

        end

        # Check if the list of custom header is valid
        # @param [Array] custom_headers
        # @return [Array]
        def has_valid_custom_headers(custom_headers)

          unless custom_headers.nil? || custom_headers.empty?
            custom_headers.each do |item|
              if item.instance_of? CustomHeader
                unless item.is_valid
                  false
                end
              end
            end
          end

          true

        end

        # Check if the list of metadata is valid
        # @param [Array] metadata
        # @return [Array]
        def has_valid_metadata(metadata)

          unless metadata.nil? || metadata.empty?
            metadata.each do |item|
              if item.instance_of? Metadata
                unless item.is_valid
                  false
                end
              end
            end
          end

          true

        end

        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_basic_message(message)

          valid_base = validate_base_message(message)
          if valid_base == SendResult.enum["Success"]
            result = validate_email_addresses(message)
          else
            result = SendResponse.new(result=valid_base)
          end

          result

        end

        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_bulk_message(message)

          valid_base = validate_base_message(message)
          if valid_base == SendResult.enum["Success"]
            result = validate_recipients(message)
          else
            result = SendResponse.new(result=valid_base)
          end

          result

        end

      end
    end
  end
end