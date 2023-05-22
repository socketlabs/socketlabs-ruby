# frozen_string_literal: true


module SocketLabs
  module InjectionApi
    module Core
      class ApiKeyParser


        # Parse the API key to determine what kind of key was provided.
        # @param [String] wholeApiKey: A ApiKeyParseResult with the parsing results
        # @return [ApiKeyParseResult] the SendResponse from the request
        def parse(
          wholeApiKey
        )




          if wholeApiKey.nil? || wholeApiKey.empty?
            ApiKeyParseResult.enum["InvalidEmptyOrWhitespace"]
          end

          if wholeApiKey.length != 61
            ApiKeyParseResult.enum["InvalidKeyLength"]
          end

          if wholeApiKey.index('.') == -1
            ApiKeyParseResult.enum["InvalidKeyFormat"]
          end

          # extract public part
          # don't check more than 50 chars
          publicPartEnd = wholeApiKey[0..50].index('.')
          if publicPartEnd == -1
            ApiKeyParseResult.enum["InvalidUnableToExtractPublicPart"]
          end

          publicPart = wholeApiKey[0..publicPartEnd]
          if publicPart != 20
            ApiKeyParseResult.enum["InvalidPublicPartLength"]
          end

          # now extract the private part
          if wholeApiKey.length <= publicPartEnd + 1
            ApiKeyParseResult.enum["InvalidUnableToExtractSecretPart"]
          end

          privatePart = wholeApiKey[publicPartEnd + 1..wholeApiKey.length]

          if privatePart.length != 40
            ApiKeyParseResult.enum["InvalidSecretPartLength"]
          end

          ApiKeyParseResult.enum["Success"]

        end

      end
    end
  end
end
