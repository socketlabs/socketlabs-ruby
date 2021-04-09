require 'net/http'

require_relative '../../version.rb'
require_relative '../retrysettings.rb'
require_relative 'injection_response_parser'

module SocketLabs
    module InjectionApi
        module Core
            class RetryHandler
                # include SocketLabsClient::InjectionApi

                private

                attr_accessor :http_client
                attr_accessor :endpoint_url
                attr_accessor :retry_settings
                attr_accessor :error_codes

                def initialize(client, endpoint, settings)

                    @http_client = client
                    @endpoint_url = endpoint
                    @retry_settings = settings
                    @error_codes = [500, 502, 503, 504]

                end

                public

                def send(request)

                    if @retry_settings.maximum_number_of_retries == 0

                        response =  @http_client.send_request(request)
                        parser = InjectionResponseParser.new
                        parser.parse(response)

                    end

                    attempts = 0

                    loop do
                    
                        wait_interval = @retry_settings.get_next_wait_interval(attempts)

                        begin

                            response = @http_client.send_request(request)

                            if @error_codes.include? response.status_code
                                raise Net::HttpServerError.new "HttpStatusCode: #{response.status_code}. Response contains server error."
                            end

                            parser = InjectionResponseParser.new
                            parser.parse(response)

                        rescue Timeout::Error => exception

                            attempts += 1
                            puts "Retry Attempt : " + attempts.to_s + " Timeout Exception : " + exception.to_s
                            if attempts > @retry_settings.maximum_number_of_retries
                                raise exception
                            end
                        
                        rescue Net::HttpServerError => exception

                            attempts += 1
                            puts "Retry Attempt : " + attempts.to_s + " Http Exception : " + exception.to_s
                            if attempts > @retry_settings.maximum_number_of_retries
                                raise exception
                            end

                        end

                    end

                end

            end
        end
    end
end