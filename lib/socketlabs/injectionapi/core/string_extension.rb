module SocketLabs
  module InjectionApi
    module Core

      class StringExtension

        private
        def strip_or_self!(str)
          str.strip! || str if str
        end

        def value_empty(value)
          value.nil? || value.empty?
        end

        def has_invalid_parts(value)
          value.count('@') != 1
        end

        def is_part_empty(value)

          unless value_empty(value)
            true
          end

          part = strip_or_self!(value)

          unless value_empty(part)
            true
          end

          part.length <= 0

        end

        def has_invalid_characters(value)
          [',', ' ', ';', 191.chr].each do |x|
            if value.include? x
              true
            end
          end
          false
        end

        public
        def is_valid_email_address(email_address)

          if value_empty(email_address)
            false
          else

            if has_invalid_parts(email_address) || has_invalid_characters(email_address)
              false
            else
              parts = email_address.split('@')
              if parts.count != 2
                false
              else
                !(is_part_empty(parts[0]) || is_part_empty(parts[1]))
              end

            end

          end


        end

      end


    end
  end
end
