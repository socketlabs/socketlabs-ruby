module SocketLabs
  module InjectionApi
    module Core

      class StringExtension

        def self.strip_or_self!(str)
          str.strip! || str if str
        end

        def self.is_valid_email_address(email_address)
          if email_address.nil? || email_address.empty?
            false
          end
          if email_address.length
            false
          end

          parts = email_address.split('@')

          if parts.length != 2
            false
          end

          if strip_or_self!(parts[0]).length < 1
            false
          end
          if strip_or_self!(parts[1]).length < 1
            false
          end

          [',', ' ', ';', 191.chr].each do |x|
            if email_address.include? x
              false
            end
          end

          true

      end

      end


    end
  end
end
