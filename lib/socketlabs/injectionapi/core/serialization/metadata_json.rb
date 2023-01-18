module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents metadata as a name and value pair.
        # To be serialized into JSON string before sending to the Injection Api.
        class MetadataJson

          # name of the metadata.
          attr_accessor :name
          # value of the metadata.
          attr_accessor :value

          # Initializes a new instance of the MetadataJson class
          # @param [String] name
          # @param [String] value
          def initialize(
            name = nil,
            value = nil
          )
            @name = name
            @value = value
          end

          # build json hash for MetadataJson
          # @return [hash]
          def to_hash
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