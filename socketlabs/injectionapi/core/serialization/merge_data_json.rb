module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MergeDataJson

          attr_accessor :per_message_merge_data,
                        :global_merge_data

          def initialize(per_message = nil, global_merge_data = nil)
            @per_message_merge_data = per_message
            @global_merge_data = global_merge_data
          end

          def to_json
            json = {}
            if @global_merge_data.length > 0
              e = Array.new
              @global_merge_data.each{ |x| e >> x.to_json}
              json[:global] = e
            end

            if @per_message_merge_data.length > 0
              e = Array.new
              @per_message_merge_data.each do |message|
                m = Array.new
                message.each{ |i| m >> i.to_json}
                e >> i
              end
              json[:perMessage] = e
            end

            json
          end

        end

      end
    end
  end
end