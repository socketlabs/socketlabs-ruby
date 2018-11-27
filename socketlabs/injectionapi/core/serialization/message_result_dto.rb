module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MessageResultDto

          attr_accessor :index,
                        :error_code,
                        :address_results

          def initialize
            @index = nil
            @error_code = nil
            @address_results = Array.new
          end

          def to_json
            json = {
                ErrorCode: @error_code,
                Index: @index
            }
            if @address_results.length > 0
              e = Array.new
              @address_results.each{ |x| e >> x.to_json}
              json[:AddressResult] = e
            end
            json
          end

        end

      end
    end
  end
end