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
                        response
                    end

                    attempts = 0

                    loop do
                        wait_interval = @retry_settings.get_next_wait_interval(attempts)

                        begin
                            response = @http_client.send_request(request)

                            if (@error_codes.include? response.status_code.to_i) && (attempts < @retry_settings.maximum_number_of_retries)
                                attempts += 1
                            else
                                response
                            end

                        rescue Timeout::Error => exception
                            attempts += 1
                            
                            if attempts > @retry_settings.maximum_number_of_retries
                                raise exception
                            end
                            sleep(wait_interval)
                        
                        rescue Exception => exception
                            raise exception
                        end

                    end

                end

            end
        end
    end
end