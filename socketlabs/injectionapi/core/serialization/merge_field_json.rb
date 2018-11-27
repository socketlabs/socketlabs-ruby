module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MergeFieldJson

          attr_accessor :field,
                        :value

          def initialize(field = nil, value = nil)
            @field = field
            @value = value
          end

          def to_json
            {
                field: @field,
                value: @value
            }
          end

        end

      end
    end
  end
end