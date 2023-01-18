require_relative '../core/string_extension.rb'

module SocketLabs
  module InjectionApi
    module Message

      # Represents metadata as a name-value pair.
      # Example:
      #
      #   metadata1 = Metadata.new
      #   metadata1.name = "name1"
      #   metadata1.value = "value1"
      #
      #   metadata2 = Metadata.new("name2", "value2")

      class Metadata

        # the name of the metadata item
        attr_accessor :name
        # the value of the metadata item
        attr_accessor :value

        # Initializes a new instance of the Metadata class
        # @param [String] name
        # @param [String] value
        def initialize(
            name = nil,
            value = nil
        )
          @name = name
          @value = value
        end

        # Determines if the Metadata is valid.
        # @return [Boolean]
        def is_valid
          valid_name = !(@name.nil? || @name.empty?)
          valid_value = !(@value.nil? || @value.empty?)

          valid_name && valid_value
        end

        # Represents the Metadata name-value pair as a String
        # @return [String]
        def to_s
            "#{@name}, #{@value}"
        end

      end
    end
  end
end