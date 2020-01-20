require_relative '../../address_result.rb'

module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MessageResultDto
          include SocketLabs::InjectionApi

          attr_accessor :index
          attr_accessor :error_code

          def initialize
            @index = nil
            @error_code = nil
            @address_results = Array.new
          end

            
          # Get the List of AddressResult objects
          # @return [Array]
          def address_results 
            @address_results
          end
          
          # Set the List of AddressResult objects
          # @param [Array] value
          def address_results=(value) 
            @address_results = Array.new
                        
            unless value.nil? || value.empty?
                value.each do |v1|                  
                  if v1.instance_of? AddressResult
                    @address_results.push(v1)
                  end
                end

            end
          end


          def to_hash
            json = {
                :ErrorCode => @error_code,
                :Index => @index
            }
            if @address_results.length > 0
              e = Array.new
              @address_results.each do |value|
                e.push(value.to_hash)
              end

              json[:AddressResult] = e
            end
            json
          end

        end
      end
    end
  end
end