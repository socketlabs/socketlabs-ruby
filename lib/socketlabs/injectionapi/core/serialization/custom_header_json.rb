module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents a custom header as a name and value pair.
        # To be serialized into JSON string before sending to the Injection Api.
        class CustomHeaderJson

          # name of the custom header.
          attr_accessor :name
          # value of the custom header.
          attr_accessor :value

          # Initializes a new instance of the CustomHeaderJson class
          # @param [String] name
          # @param [String] value
          def initialize(
            name = nil,
            value = nil
          )
            @name = name
            @value = value
          end

          # build json hash for CustomHeaderJson
          # @return [hash]
          def to_json
            {
              :name => @name,
              :value => @value
            }
          end

        end

      end
    end
  end
end