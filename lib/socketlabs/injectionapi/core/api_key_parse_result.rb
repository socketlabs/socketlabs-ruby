# frozen_string_literal: true


module SocketLabs
  module InjectionApi
    module Core
      class ApiKeyParseResult
        def self.enum
        {
          # No result could be produced.
          "None" =>
            {
              :name => "None",
              :value =>0,
            },
          # The key was found to be blank or invalid.
          "InvalidEmptyOrWhitespace" =>
            {
              :name => "InvalidEmptyOrWhitespace",
              :value =>1,
            },
          # The public portion of the key was unable to be parsed.
          "InvalidUnableToExtractPublicPart" =>
            {
              :name => "InvalidUnableToExtractPublicPart",
              :value =>2,
            },
          # The secret portion of the key was unable to be parsed.
          "InvalidUnableToExtractSecretPart" =>
            {
              :name => "InvalidUnableToExtractSecretPart",
              :value =>3,
            },
          # Key was successfully parsed.
          "Success" =>
            {
              :name => "Success",
              :value =>4,
            }
        }
        end
      end
    end
  end
end