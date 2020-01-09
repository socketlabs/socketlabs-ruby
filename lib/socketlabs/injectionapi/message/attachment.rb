require 'base64'
require "../../core/string_extension"

module SocketLabs
  module InjectionApi
    module Message

      # Represents a custom header as a name-value pair.
      # Example:
      #
      #   attachment1 = Attachment(file_path="./bus.png")
      #
      #   attachment2 = Attachment("bus", "image/png", "../bus.png")
      #
      #   attachment3 = Attachment("bus", "image/png", content=bytes())
      #   attachment3.add_custom_header("name1", "value1")
      #   attachment3.add_custom_header("name2", "value2")
      class Attachment

        # Name of attachment (displayed in email clients).
        attr_accessor :name
        # BASE64 encoded string containing the contents of an attachment.
        attr_accessor :content
        # The MIME type of the attachment.
        attr_accessor :mime_type
        # A list of custom headers for the attachment.
        attr_accessor :custom_headers
        # The local file path for your attachment, used to stream the file in.
        attr_accessor :file_path
        # The contentId for your attachment, used if you need to reference the attachment in your email content.
        attr_accessor :content_id

        # Initializes a new instance of the CustomHeader class
        # @param [String] name
        # @param [String] content
        def initialize(
            name = nil,
            content = nil,
            mime_type = nil,
            custom_headers = nil,
            file_path = nil,
            content_id = nil
        )

          unless StringExtension.is_nil_or_white_space(file_path)
            readfile(file_path)
          end

          unless StringExtension.is_nil_or_white_space(name)
            @name = name
          end

          unless StringExtension.is_nil_or_white_space(mime_type)
            @mime_type = mime_type
          end

          @content_id = content_id

          @custom_headers = []
          unless custom_headers.nil? || merge_data.empty?
            @custom_headers = custom_headers
          end

          unless StringExtension.is_nil_or_white_space(content)
            @content = content
          end

        end

        # Read the specified file and get a str containing the resulting binary data.
        # @param [String] file_path
        def readfile(file_path)

          @file_path = file_path
          @name = File.basename(file_path)
          @mime_type = get_mime_type_from_ext(File.extname(file_path))

          file = File.open("file_path", "rb")
          encoded_string = Base64.encode64(file.read)
          @content = encoded_string

        end

        # Takes a file extension, minus the '.', and returns the corresponding MimeType for the given extension.
        # @param [String] extension
        # @return [String] mime type
        def get_mime_type_from_ext(extension)

           types = {
            :txt => "text/plain",
            :ini=>"text/plain",
            :sln=>"text/plain",
            :cs=>"text/plain",
            :js=>"text/plain",
            :config=>"text/plain",
            :vb=>"text/plain",
            :jpg=>"image/jpeg",
            :jpeg=>"image/jpeg",
            :bmp=>"image/bmp",
            :csv=>"text/csv",
            :doc=>"application/msword",
            :docx=>"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            :gif=>"image/gif",
            :html=>"text/html",
            :pdf=>"application/pdf",
            :png=>"image/png",
            :ppt=>"application/vnd.ms-powerpoint",
            :pptx=>"application/vnd.openxmlformats-officedocument.presentationml.presentation",
            :xls=>"application/vnd.ms-excel",
            :xlsx=>"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            :xml=>"application/xml",
            :zip=>"application/x-zip-compressed",
            :wav=>"audio/wav",
            :eml=>"message/rfc822",
            :mp3=>"audio/mpeg",
            :mp4=>"video/mp4",
            :mov=>"video/quicktime"
           }
          mime = types[extension]

            if StringExtension.is_nil_or_white_space(mime)
            "application/octet-stream"
            end
            mime
        end

        # Add a CustomHeader to the attachment
        # @param [String] name
        # @param [String] value
        def add_custom_header(name, value)
          @custom_headers.push(CustomHeader.new(name, value))
        end

        # Represents the Attachment as a String
        # @return [String]
        def to_s
            "#{@name}, #{@mime_type}"
        end


      end
    end
  end
end