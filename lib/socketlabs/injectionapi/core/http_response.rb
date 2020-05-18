
module SocketLabs
  module InjectionApi
    module Core

      class HttpResponse

        attr_reader :status_code
        attr_reader :body
        attr_reader :headers

        def initialize(response)
          @status_code = response.code
          @body = response.body
          @headers = response.to_hash
        end

        # Returns the body as a hash
        def to_hash
          @parsed_body ||= JSON.parse(@body, symbolize_names: true)
        end

      end

    end
  end
end
