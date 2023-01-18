require_relative '../core/string_extension.rb'

module SocketLabs
  module InjectionApi
    module Message

      # Represents metadata as a key-value pair.
      # Example:
      #
      #   metadata1 = Metadata.new
      #   metadata1.key = "key1"
      #   metadata1.value = "value1"
      #
      #   metadata2 = Metadata.new("key2", "value2")

      class Metadata

        # the key of the metadata item
        attr_accessor :key
        # the value of the metadata item
        attr_accessor :value

        # Initializes a new instance of the Metadata class
        # @param [String] key
        # @param [String] value
        def initialize(
          key = nil,
            value = nil
        )
          @key = key
          @value = value
        end

        # Determines if the Metadata is valid.
        # @return [Boolean]
        def is_valid
          valid_key = !(@key.nil? || @key.empty?)
          valid_value = !(@value.nil? || @value.empty?)

          valid_key && valid_value
        end

        # Represents the Metadata key-value pair as a String
        # @return [String]
        def to_s
            "#{@key}, #{@value}"
        end

      end
    end
  end
end