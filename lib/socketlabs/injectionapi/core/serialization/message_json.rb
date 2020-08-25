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
          # the AMP portion of the message body.
          attr_accessor :amp_body
          # the api template.
          attr_accessor :api_template
          # the custom mailing id.
          attr_accessor :mailing_id
          # the custom message id.
          attr_accessor :message_id
          # the optional character set. Default is UTF-8
          attr_accessor :charset
          # the from email address.
          attr_accessor :from_email_address
          # the optional reply to email address.
          attr_accessor :reply_to
          # the the MergeDataJson for the message
          attr_accessor :merge_data


          def initialize

            @subject = nil
            @plain_text_body = nil
            @html_body = nil
            @amp_body = nil 
            @api_template = nil
            @mailing_id = nil
            @message_id = nil
            @charset = nil
            @from_email_address = nil
            @reply_to = nil
            @merge_data = MergeDataJson.new
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
          def to_hash

            json = {
                :from => @from_email_address.to_hash
            }

            unless @subject.nil? || @subject.empty?
              json[:subject] = @subject
            end

            unless @html_body.nil? || @html_body.empty?
              json[:htmlBody] = @html_body
            end

            unless @amp_body.nil? || @amp_body.empty?
              json[:ampBody] = @amp_body
            end

            unless @plain_text_body.nil? || @plain_text_body.empty?
              json[:textBody] = @plain_text_body
            end

            unless @api_template.nil?
              json[:apiTemplate] = @api_template
            end

            unless @mailing_id.nil? || @mailing_id.empty?
              json[:mailingId] = @mailing_id
            end

            unless @message_id.nil? || @message_id.empty?
              json[:messageId] = @message_id
            end

            unless @reply_to.nil?
              json[:replyTo] = @reply_to.to_hash
            end

            unless @charset.nil? || @charset.empty?
              json[:charSet] = @charset
            end

            unless @to_email_address.nil? || @to_email_address.length == 0
              e = Array.new
              @to_email_address.each do |value|
                  e.push(value.to_hash)
              end
              json[:to] = e
            end

            unless @cc_email_address.nil? || @cc_email_address.length == 0
              e = Array.new
              @cc_email_address.each do |value|
                e.push(value.to_hash)
              end
              json[:cc] = e
            end

            unless @bcc_email_address.nil? || @bcc_email_address.length == 0
              e = Array.new
              @bcc_email_address.each do |value|
                e.push(value.to_hash)
              end
              json[:bcc] = e
            end

            unless @custom_headers.nil? || @custom_headers.length == 0
              e = Array.new
              @custom_headers.each do |value|
                e.push(value.to_hash)
              end
              json[:customHeaders] = e
            end

            unless @attachments.nil? || @attachments.length == 0
              e = Array.new
              @attachments.each do |value|
                e.push(value.to_hash)
              end
              json[:attachments] = e
            end

            unless @merge_data.nil? || @merge_data.empty
                json[:mergeData] = @merge_data.to_hash
            end

            json

          end

        end
      end
    end
  end
end

