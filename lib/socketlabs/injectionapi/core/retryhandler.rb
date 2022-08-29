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

                    attempts = 0
                    exception = nil

                    loop do
                        wait_interval = @retry_settings.get_next_wait_interval(attempts)
                        attempts += 1

                        begin
                            response = @http_client.send_request(request)

                            if @error_codes.include? response.status_code.to_i
                                exception = SocketLabs::InjectionApi::Exceptions::ServerException.new("Failed to send email. Received #{response.status_code} from server.")
                                sleep(wait_interval)
                            else
                                return response
                            end

                        rescue Timeout::Error => exception
                            exception = exception

                            break if attempts > @retry_settings.maximum_number_of_retries
                            sleep(wait_interval)
                        
                        rescue Exception => exception
                            raise exception
                        end

                        break if attempts > @retry_settings.maximum_number_of_retries
                    end

                    raise exception if exception

                    false
                end

            end
        end
    end
end