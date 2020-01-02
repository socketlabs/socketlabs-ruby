require "../../core/string_extension"
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
          # the the list of MergeDataJson
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
          def attachments(value)
            @attachments = Array.new
            if value.nil? || value.empty
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
              @attachments.push(v1)
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
          def custom_headers(value)
            @custom_headers = Array.new
            if value.nil? || value.empty
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
              @custom_headers.push(v1)
            end
          end

          # Get the To email address list
          # @return [Array]
          def to_email_address
            @to_email_address
          end
          # Set the To email address list
          # @param [Array] value
          def to_email_address(value)
            @to_email_address = Array.new
            if value.nil? || value.empty
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
          def cc_email_address(value)
            @cc_email_address = Array.new
            if value.nil? || value.empty
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
          def bcc_email_address(value)
            @bcc_email_address = Array.new
            if value.nil? || value.empty
              value.each do |v1|
                if v1.instance_of? AddressJson
                  @bcc_email_address.push(v1)
                end
              end
            end
          end
        end
      end
    end
  end
end

