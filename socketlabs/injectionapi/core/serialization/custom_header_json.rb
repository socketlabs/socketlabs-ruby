module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class CustomHeaderJson

          attr_accessor :name,
                        :value

          def initialize(name = nil, value = nil)
            @name = name
            @value = value
          end

          def to_json
            {
                name: @name,
                value: @value
            }
          end

        end

      end
    end
  end
end