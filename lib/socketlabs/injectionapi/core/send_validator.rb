require "../../core/string_extension"

module SocketLabs
  module InjectionApi
    module Core

      # Used by the SocketLabsClient to conduct basic validation on the message before sending to the Injection API.
      class SendValidator

        private
        # Maximum recipient threshold
        def maximum_recipients_per_message
          50
        end

        public
        # Validate the required fields of a BasicMessage.
        # Fields validated are Subject, From Address, Reply To (if set),
        # Message Body, and Custom Headers (if set)
        # @param [MessageBase] message
        # @return [SendResult]
        def validate_base_message(message)

          unless has_subject(message)
            SendResult.enum[:MessageValidationEmptySubject]
          end
          unless has_from_email_address(message)
            SendResult.enum[:EmailAddressValidationMissingFrom]
          end
          unless message.from_email_address.is_valid
            SendResult.enum[:EmailAddressValidationInvalidFrom]
          end
          unless has_valid_reply_to(message)
            SendResult.enum[:RecipientValidationInvalidReplyTo]
          end
          unless has_message_body(message)
            SendResult.enum[:MessageValidationEmptyMessage]
          end
          unless has_valid_custom_headers(message.custom_headers)
            SendResult.enum[:MessageValidationInvalidCustomHeaders]
          end

          SendResult.Success

        end

        def nil_zero?
          self.nil? || self == 0
        end

        # Check if the message has a subject
        # @param [MessageBase] message
        # @return [Boolean]
        def has_subject(message)
            !StringExtension.is_nil_or_white_space(message.subject)
        end

        # Check if the message has a valid From Email Address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_message_body(message)

          if has_api_template(message)
            true
          end

          has_html_body = !StringExtension.is_nil_or_white_space(message.html_body)
          has_plain_text_body = !StringExtension.is_nil_or_white_space(message.plain_text_body)

          has_html_body || has_plain_text_body

        end

        # Check if an ApiTemplate was specified and is valid
        # @param [MessageBase] message
        # @return [Boolean]
        def has_api_template(message)
          !StringExtension.is_nil_or_white_space(message.api_template)
        end

        # Check if the message has a valid From Email Address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_from_email_address(message)

          if message.from_email_address.nil? || message.from_email_address.empty?
           false
          end

          !StringExtension.is_nil_or_white_space(message.from_email_address.email_address)

        end

        # Check if reply_to_email_address is a valid to email address
        # @param [MessageBase] message
        # @return [Boolean]
        def has_valid_reply_to(message)

          if message.reply_to_email_address.nil? || message.reply_to_email_address.empty?
            false
          end

          !message.reply_to_email_address.is_valid

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
            SendResponse.new(result=SendResult.enum[:RecipientValidationNoneInMessage])
          end
          if rec_count > maximum_recipients_per_message
            SendResponse.new(result=SendResult.enum[:RecipientValidationMaxExceeded])
          end
          invalid_rec = has_invalid_email_addresses(message)
          unless invalid_rec.nil? || invalid_rec.empty?
            SendResponse.new(result=SendResult.enum[:RecipientValidationInvalidRecipients], address_results=invalid_rec)
          end

          SendResponse.new(result=SendResult.enum[:Success])

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

          unless message.to_email_address.nil? || message.to_email_address.empty?
            SendResponse.new(result=SendResult.enum[:RecipientValidationMissingTo])
          end
          if message.to_email_address.length > maximum_recipients_per_message
            SendResponse.new(result=SendResult.enum[:RecipientValidationMaxExceeded])
          end
          invalid_rec = has_invalid_recipients(message)
          unless invalid_rec.nil? || invalid_rec.empty?
            SendResponse.new(result=SendResult.enum[:RecipientValidationInvalidRecipients], address_results=invalid_rec)
          end

          SendResponse.new(result=SendResult.enum[:Success])
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

          invalid_to = find_invalid_email_addresses(message.to_recipient)
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
              end
            end
          end

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
              end
            end
          end

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

        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_basic_message(message)

          valid_base = validate_base_message(message)
          if valid_base == SendResult.enum[:Success]
            validate_email_addresses(message)
          end

          SendResponse.new(result=valid_base)
        end

        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_bulk_message(message)

          valid_base = validate_base_message(message)
          if valid_base == SendResult.enum[:Success]
            validate_recipients(message)
          end

          SendResponse.new(result=valid_base)

        end

        # Validate a basic email message before sending to the Injection API.
        # @param [BasicMessage] message
        # @return [SendResponse]
        def validate_message(message)

          if message.instance_of? BasicMessage
            validate_basic_message(message)
          end

          if message.instance_of? BulkMessage
            validate_bulk_message(message)
          end

        end

        # Validate the ServerId and Api Key pair prior before sending to the Injection API.
        # @param [Integer] server_id
        # @param [String] api_key
        # @return [SendResponse]
        def validate_credentials(server_id, api_key)

          unless StringExtension.is_nil_or_white_space(api_key)
            SendResponse.new(result=SendResult.enum[:AuthenticationValidationFailed])
          end

          unless StringExtension.is_nil_or_white_space(server_id) && server_id > 0
            SendResponse.new(result=SendResult.enum[:AuthenticationValidationFailed])
          end

          SendResponse.new(result=SendResult.enum[:Success])
        end

      end
    end
  end
end