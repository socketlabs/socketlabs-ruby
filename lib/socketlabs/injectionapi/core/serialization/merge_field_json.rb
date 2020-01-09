module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents a merge field as a field and value pair.
        # To be serialized into JSON string before sending to the Injection Api.
        class MergeFieldJson

          # The field of your merge field.
          attr_accessor :field
          # The merge field value.
          attr_accessor :value

          # Initializes a new instance of the MergeFieldJson class
          # @param [String] field
          # @param [String] value
          def initialize(
            field = nil,
            value = nil
          )
            @field = field
            @value = value
          end

          # build json hash for MergeFieldJson
          # @return [hash]
          def to_json
            {
              :field => @field,
              :value => @value
            }
          end

        end

      end
    end
  end
end