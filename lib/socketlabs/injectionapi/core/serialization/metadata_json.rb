module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents metadata as a key and value pair.
        # To be serialized into JSON string before sending to the Injection Api.
        class MetadataJson

          # key of the metadata.
          attr_accessor :key
          # value of the metadata.
          attr_accessor :value

          # Initializes a new instance of the MetadataJson class
          # @param [String] key
          # @param [String] value
          def initialize(
            key = nil,
            value = nil
          )
            @key = key
            @value = value
          end

          # build json hash for MetadataJson
          # @return [hash]
          def to_hash
            {
              :key => @key,
              :value => @value
            }
          end

        end

      end
    end
  end
end