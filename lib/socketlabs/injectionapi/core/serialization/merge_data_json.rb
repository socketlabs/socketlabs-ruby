module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MergeDataJson
         
          # @param [Array] per_message
          # @param [Array] global_merge_data
          def initialize(
              per_message = nil, 
              global_merge_data = nil
            )
            @per_message_merge_data = per_message
            @global_merge_data = global_merge_data
          end


          # Get merge field data for each message.
          # @return [Array]
          def per_message_merge_data 
            @per_message_merge_data
          end
          
          # Set merge field data for each message.
          # @param [Array] value
          def per_message_merge_data=(value) 
            @per_message_merge_data = Array.new
                        
            if value.nil? || value.empty
                value.each do |v1|                  
                  if v1.instance_of? MergeFieldJson
                    l1 = Array.new
                    v1.each do |v2|                  
                      if v2.instance_of? MergeFieldJson
                        l1.push(v2)
                      end
                    end
                    @per_message_merge_data.push(l1)
                  end
                end                       

          end
          
          # Get merge field data for all messages in the request
          # @return [Array]
          def global_merge_data 
            @global_merge_data
          end
          
          # Set merge field data for all messages in the request
          # @param [Array] value
          def global_merge_data=(value) 
            @global_merge_data = Array.new
                        
            if value.nil? || value.empty
                value.each do |v1|                  
                  if v1.instance_of? MergeFieldJson:
                    @global_merge_data.push(v1)
                  end
                end                       

          end

          # build json hash for MergeDataJson
          # @return [hash]
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
  end
end