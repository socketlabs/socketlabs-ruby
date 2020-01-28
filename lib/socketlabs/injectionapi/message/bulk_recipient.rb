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
          include SocketLabs::InjectionApi
          include SocketLabs::InjectionApi::Core

        # A valid email address.
        attr_accessor :email_address
        # The friendly or display name for the recipient.
        attr_accessor :friendly_name
        # Merge data unique to the instance of the bulk recipient.
        attr_accessor :merge_data

        # Creates a new instance of the BulkRecipient class.
        # @param [String] email_address
        # @param [Hash] arguments
        def initialize(
            email_address,
            arguments = nil
        )
          @email_address = email_address
          @merge_data = Array.new

          unless arguments.nil? || arguments.empty?

            unless arguments[:friendly_name].nil? || arguments[:friendly_name].empty?
              @friendly_name = arguments[:friendly_name]
            end

            unless arguments[:merge_data].nil? || arguments[:merge_data].empty?
              unless arguments[:merge_data].nil? || arguments[:merge_data].empty?
                arguments[:merge_data].each do |value|
                  if value.instance_of? MergeData
                    @merge_data.push(value)
                  elsif value.instance_of? Hash
                    @merge_data.push(MergeData.new(value[:key], value[:value]))
                  end
                end
              end
            end

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
          StringExtension.new.is_valid_email_address(@email_address)
        end

        # Represents the BulkRecipient as a string
        # @return [String]
        def to_s
          if @friendly_name.nil? || @friendly_name.empty?
            @email_address
          else
            "#{@friendly_name} <#{@email_address}>"
          end

        end


      end
    end
  end
end