require_relative '../core/string_extension.rb'

module SocketLabs
  module InjectionApi
    module Message

        # Represents an individual BulkRecipient for a message.
        # Example:
        #   email_address1 = BulkRecipient.new("recipient@example.com")
        #
        #   email_address2 = BulkRecipient.new("recipient@example.com", "Recipient")
        #
        #   email_address3 = BulkRecipient.new("recipient@example.com", "Recipient")
        #   email_address3.merge_data.push(MergeData.new("name1", "value1"))
        #   email_address3.add_merge_data("name2", "value2")
        class BulkRecipient

        # A valid email address.
        attr_accessor :email_address
        # The friendly or display name for the recipient.
        attr_accessor :friendly_name
        # Merge data unique to the instance of the bulk recipient.
        attr_accessor :merge_data

        # Creates a new instance of the BulkRecipient class.
        # @param [String] email_address
        # @param [String] friendly_name
        # @param [Array] merge_data Array of of MergeData
        def initialize(
            email_address,
            friendly_name = nil,
            merge_data = nil
        )
          @email_address = email_address
          @friendly_name = friendly_name
          @merge_data = []
          unless merge_data.nil? || merge_data.empty?
            @merge_data = merge_data
          end
        end

        # Add to an Array of MergeData
        # @param [String] key
        # @param [String] value
        def add_merge_data(key, value)
          @merge_data.push(MergeData.new(key, value))
        end

        # Determines if the BulkRecipient is valid. Does simple syntax validation on the email address.
        # @return [Boolean]
        def is_valid
          StringExtension.is_valid_email_address(@email_address)
        end

        # Represents the BulkRecipient as a string
        # @return [String]
        def to_s
          if StringExtension.is_nil_or_white_space(@friendly_name)
            @email_address
          else
            "#{@friendly_name} <#{@email_address}>"
          end

        end


      end
    end
  end
end