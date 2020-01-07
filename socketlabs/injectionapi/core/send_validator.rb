require "../../core/string_extension"

module SocketLabs
  module InjectionApi
    module Core

      class SendValidator


        # Maximum recipient threshold
        maximumRecipientsPerMessage = 50


        # Validate the required fields of a BasicMessage.
        # Fields validated are Subject, From Address, Reply To (if set),
        # Message Body, and Custom Headers (if set)
        # @param [MessageBase] message
        # @return [SendResult]
        def validate_base_message(message: MessageBase)

          if !has_subject(message)
              SendResult.MessageValidationEmptySubject
          end
          if !has_from_email_address(message)
              SendResult.EmailAddressValidationMissingFrom
          end
          if !message.from_email_address.isvalid()
              SendResult.EmailAddressValidationInvalidFrom
          end
          if !has_valid_reply_to_email_address(message)
              SendResult.RecipientValidationInvalidReplyTo
          end
          if !has_message_body(message)
              SendResult.MessageValidationEmptyMessage
          end
          if message.custom_headers.nil? || len(message.custom_headers) > 0
              if not has_valid_custom_headers(message.custom_headers)
                  SendResult.MessageValidationInvalidCustomHeaders
              end
          end

          SendResult.Success

        end

        def nil_zero?
          self.nil? || self == 0
        end

        # Check if the message has a subject
        # :param message: message to validate
        # :type message: MessageBase
        # :return the result
        # :rtype bool
        def has_subject(message: MessageBase)
              return !StringExtension.is_none_or_white_space(message.subject)
        end


      end
    end
  end
end