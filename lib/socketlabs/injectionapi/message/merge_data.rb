require "../../core/string_extension"

module SocketLabs
  module InjectionApi
    module Message

      # Represents MergeData as a key and value pair.
      # Example:
      #   data1 = MergeData.new("key1", "value1")

      class MergeData

        # the MergeData key
        attr_accessor :key
        # the value of the custom header
        attr_accessor :value

        # Initializes a new instance of the CustomHeader class
        # @param [String] key
        # @param [String] value
        def initialize(
            key = nil,
            value = nil
        )
          @key = key
          @value = value
        end

        # A quick check to ensure that the MergeData is valid.
        # @return [Boolean]
        def is_valid
          valid_key = StringExtension.is_nil_or_white_space(@key)
          valid_value = StringExtension.is_nil_or_white_space(@value)
          if valid_key && valid_value
            true
          end
          false
        end

        # Represents the CustomHeader name-value pair as a String
        # @return [String]
        def to_s
            "#{@name}, #{@value}"
        end


      end
    end
  end
end