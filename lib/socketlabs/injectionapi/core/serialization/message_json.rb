module SocketLabs
  module InjectionApi
    module Core
      module Serialization

        class MessageJson

          # the message subject.
          attr_accessor :subject
          # the plain text portion of the message body.
          attr_accessor :plain_text_body
          # the HTML portion of the message body.
          attr_accessor :html_body
          # the api template.
          attr_accessor :api_template
          # the custom mailing id.
          attr_accessor :mailing_id
          # the custom message id.
          attr_accessor :message_id
          # the optional character set. Default is UTF-8
          attr_accessor :charset
          # the from email address.
          attr_accessor :from_email
          # the optional reply to email address.
          attr_accessor :reply_to
          # the the MergeDataJson for the message
          attr_accessor :merge_data


          def initialize

            @subject = nil
            @plain_text_body = nil
            @html_body = nil
            @api_template = nil
            @mailing_id = nil
            @message_id = nil
            @charset = nil
            @from_email = nil
            @reply_to = nil
            @merge_data = nil
            @attachments = Array.new
            @custom_headers = Array.new
            @to_email_address = Array.new
            @cc_email_address = Array.new
            @bcc_email_address = Array.new

          end

          # Get the list of attachments.
          # @return [Array]
          def attachments
            @attachments
          end
          # Set the list of AttachmentJson.
          # @param [Array] value
          def attachments=(value)
            @attachments = Array.new
            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? AttachmentJson
                  @attachments.push(v1)
                end
              end
            end
          end

          # Add an AttachmentJson to the attachments list.
          # @param [AttachmentJson] value
          def add_attachments(value)
            if value.instance_of? AttachmentJson
              @attachments.push(value)
            end
          end

          #custom_headers
          # Get the list of CustomHeaderJson.
          # @return [Array]
          def custom_headers
            @custom_headers
          end
          # Set the list of CustomHeaderJson.
          # @param [Array] value
          def custom_headers=(value)
            @custom_headers = Array.new
            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? CustomHeaderJson
                  @custom_headers.push(v1)
                end
              end
            end
          end

          # Add a CustomHeaderJson to the custom header list
          # @param [CustomHeaderJson] value
          def add_custom_header(value)
            if value.instance_of? CustomHeaderJson
              @custom_headers.push(value)
            end
          end

          # Get the To email address list
          # @return [Array]
          def to_email_address
            @to_email_address
          end
          # Set the To email address list
          # @param [Array] value
          def to_email_address=(value)
            @to_email_address = Array.new
            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? AddressJson
                  @to_email_address.push(v1)
                end
              end
            end
          end

          # Get the CC email address list
          # @return [Array]
          def cc_email_address
            @cc_email_address
          end
          # Set the CC email address list
          # @param [Array] value
          def cc_email_address=(value)
            @cc_email_address = Array.new
            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? AddressJson
                  @cc_email_address.push(v1)
                end
              end
            end
          end

          # Get the BCC email address list
          # @return [Array]
          def bcc_email_address
            @bcc_email_address
          end
          # Set the BCC email address list
          # @param [Array] value
          def bcc_email_address=(value)
            @bcc_email_address = Array.new
            unless value.nil? || value.empty?
              value.each do |v1|
                if v1.instance_of? AddressJson
                  @bcc_email_address.push(v1)
                end
              end
            end
          end

          # build json hash for MessageJson
          # @return [hash]
          def to_json

            json = {
                :from => @from_email.to_json
            }

            if StringExtension.is_nil_or_white_space(@subject)
              json[:subject] = @subject
            end

            if StringExtension.is_nil_or_white_space(@html_body)
              json[:htmlBody] = @html_body
            end

            if StringExtension.is_nil_or_white_space(@plain_text_body)
              json[:textBody] = @plain_text_body
            end

            if StringExtension.is_nil_or_white_space(@api_template)
              json[:apiTemplate] = @api_template
            end

            if StringExtension.is_nil_or_white_space(@mailing_id)
              json[:mailingId] = @mailing_id
            end

            if StringExtension.is_nil_or_white_space(@message_id)
              json[:messageId] = @message_id
            end

            if StringExtension.is_nil_or_white_space(@reply_to)
              json[:replyTo] = @reply_to
            end

            if StringExtension.is_nil_or_white_space(@charset)
              json[:charSet] = @charset
            end

            if @to_email_address.length > 0
              e = Array.new
              @to_email_address.each{ |x| e >> x.to_json}
              json[:to] = e
            end

            if @cc_email_address.length > 0
              e = Array.new
              @cc_email_address.each{ |x| e >> x.to_json}
              json[:cc] = e
            end

            if @bcc_email_address.length > 0
              e = Array.new
              @bcc_email_address.each{ |x| e >> x.to_json}
              json[:bcc] = e
            end

            if @custom_headers.length > 0
              e = Array.new
              @custom_headers.each{ |x| e >> x.to_json}
              json[:customHeaders] = e
            end

            if @attachments.length > 0
              e = Array.new
              @attachments.each{ |x| e >> x.to_json}
              json[:attachments] = e
            end

            if @merge_data.nil?
              json[:mergeData] = @merge_data.to_json
            end

            json

          end

        end
      end
    end
  end
end

