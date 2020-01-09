require 'base64'
require_relative '../core/string_extension.rb'

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
        # @param [merge] arguments - accepted arguments file_path, name, mime_type, content_id, custom_headers, content

        def initialize(arguments)

          unless arguments[:file_path].nil? || arguments[:file_path].empty?
            readfile(arguments[:file_path])
          end

          unless arguments[:name].nil? || arguments[:name].empty?
            @name = arguments[:name]
          end

          unless arguments[:mime_type].nil? || arguments[:mime_type].empty?
            @mime_type = arguments[:mime_type]
          end

          @content_id = arguments[:content_id]

          @custom_headers = []
          unless arguments[:custom_headers].nil? || arguments[:custom_headers].empty?
            @custom_headers = arguments[:custom_headers]
          end

          unless arguments[:content].nil? || arguments[:content].empty?
            @content = arguments[:content]
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
          extension[0]=''
          types = [
            { :ext => "txt", :mime_type => "text/plain" },
            { :ext => "ini", :mime_type => "text/plain" },
            { :ext => "sln", :mime_type => "text/plain" },
            { :ext => "cs", :mime_type => "text/plain" },
            { :ext => "js", :mime_type => "text/plain" },
            { :ext => "config", :mime_type => "text/plain" },
            { :ext => "vb", :mime_type => "text/plain" },
            { :ext => :"jpg", :mime_type => "image/jpeg" },
            { :ext => "jpeg", :mime_type => "image/jpeg" },
            { :ext => "bmp", :mime_type => "image/bmp" },
            { :ext => "csv", :mime_type => "text/csv" },
            { :ext => "doc", :mime_type => "application/msword" },
            { :ext => "docx", :mime_type => "application/vnd.openxmlformats-officedocument.wordprocessingml.document" },
            { :ext => "gif", :mime_type => "image/gif" },
            { :ext => "html", :mime_type => "text/html" },
            { :ext => "pdf", :mime_type => "application/pdf" },
            { :ext => "png", :mime_type => "image/png" },
            { :ext => "ppt", :mime_type => "application/vnd.ms-powerpoint" },
            { :ext => "pptx", :mime_type => "application/vnd.openxmlformats-officedocument.presentationml.presentation" },
            { :ext => "xls", :mime_type => "application/vnd.ms-excel" },
            { :ext => "xlsx", :mime_type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" },
            { :ext => "xml", :mime_type => "application/xml" },
            { :ext => "zip", :mime_type => "application/x-zip-compressed" },
            { :ext => "wav", :mime_type => "audio/wav" },
            { :ext => "eml", :mime_type => "message/rfc822" },
            { :ext => "mp3", :mime_type => "audio/mpeg" },
            { :ext => "mp4", :mime_type => "video/mp4" },
            { :ext => "mov", :mime_type => "video/quicktime" }
          ]
          mime = types.find {|x| x[:ext] == extension}

            unless mime.nil? || mime.empty?
            "application/octet-stream"
            end
            mime[:mime_type]
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