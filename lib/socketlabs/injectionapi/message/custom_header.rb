require_relative '../core/string_extension.rb'

module SocketLabs
  module InjectionApi
    module Message

      # Represents a custom header as a name-value pair.
      # Example:
      #
      #   header1 = CustomHeader.new
      #   header1.name = "name1"
      #   header1.value = "value1"
      #
      #   header2 = CustomHeader.new("name2", "value2")

      class CustomHeader

        # the name of the custom header
        attr_accessor :name
        # the value of the custom header
        attr_accessor :value

        # Initializes a new instance of the CustomHeader class
        # @param [String] name
        # @param [String] value
        def initialize(
            name = nil,
            value = nil
        )
          @name = name
          @value = value
        end

        # Determines if the CustomHeader is valid.
        # @return [Boolean]
        def is_valid
          valid_name = StringExtension.is_nil_or_white_space(@name)
          valid_value = StringExtension.is_nil_or_white_space(@value)
          if valid_name && valid_value
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