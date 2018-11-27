require "../socketlabs/injectionapi/core/string_extension"

module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class AttachmentJson
          include SocketLabs::InjectionApi::Core

          attr_accessor :name,
                        :mime_type,
                        :content_id,
                        :content,
                        :custom_headers

          def initialize
            @name = nil
            @mime_type = nil
            @content_id = nil
            @content = nil
            @custom_headers = Array.new
          end

          def to_json
            json =
            {
                name: @name,
                content: @value,
                contentType: @mime_type
            }
            if StringExtension.is_nil_or_white_space(@content_id)
              json[:contentId] = @content_id
            end
            if @custom_headers.length > 0
              e = Array.new
              @custom_headers.each{ |x| e >> x.to_json}
              json[:customHeaders] = e
            end
            json
          end

        end

      end
    end
  end
end