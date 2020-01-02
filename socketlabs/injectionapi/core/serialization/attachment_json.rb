require "../../core/string_extension"

module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        # Represents a message attachment in the form of a byte array.
        # To be serialized into JSON string before sending to the Injection Api.

        class AttachmentJson
          include SocketLabs::InjectionApi::Core

          # the name of attachment
          attr_accessor :name
          # the MIME type of the attachment.
          attr_accessor :mime_type
          # ContentId for an Attachment.
          attr_accessor :content_id
          # Content of an Attachment. The BASE64 encoded str.
          attr_accessor :content
          # the list of custom headers added to the attachment.
          attr_accessor :custom_headers

          # Initializes a new instance of the AttachmentJson class
          def initialize
            @name = nil
            @mime_type = nil
            @content_id = nil
            @content = nil
            @custom_headers = Array.new
          end

          # build json hash for AttachmentJson
          # @return [hash]
          def to_json
            json =
            {
                :name=> @name,
                :content=> @value,
                :contentType=> @mime_type
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