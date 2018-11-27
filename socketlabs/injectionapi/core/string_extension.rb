module SocketLabs
  module InjectionApi
    module Core

      class StringExtension

        def self.is_nil_or_white_space(value)
          value.nil? || value.empty?
        end

        def self.is_valid_email_address(email_address)
          if is_nil_or_white_space(email_address)
            false
          end
          if email_address.length
            false
          end

          parts = Array.new
          email_address.each_line('@'){|x| parts >> x}

          if parts.length != 2
            false
          end

          if parts[0].strip.length < 1
            false
          end
          if parts[1].strip.length < 1
            false
          end

          [',', ' ', ';', 191.chr.ord].each do |x|
            if email_address.index(x)
              false
            end
          end

          true

      end

      end

    end
  end
end
